import json
import os

from requests import request, Response

import utils

def buscar_guias_cancelaveis():
    json_debitos = list()
    rows_guias = utils.fetch_results("""
    select a.num_cadastro, a.num_documento, a.idguia, c.id_gerado, c.situacao
    from guia_iss_govdigital_canc a
    left join  integracao_db_lagoa_santa.public.guia_iss_govdigital b on a.idguia = b.idguia
    left join lancamento c on b.id = c.guia_iss_govdigital_id
    where c.guia_iss_govdigital_id is not null and c.situacao != 'ERRO' and a.idguia not in (SELECT guia_iss_govdigital_id FROM cancelamento)""")
    for row in rows_guias:
        id_debito = row[3]
        try:
            resultado_debito = request(url=os.getenv("API_PARCEIROS_URL_BASE") + "/lancamentos/debitos/" + str(id_debito),
                           method="GET",
                           headers={"user-access": os.getenv("API_TERCEIRO_USER_ACCESS"),
                                    "Authorization": 'Bearer ' + os.getenv("API_TERCEIRO_AUTHORIZATION")},
                           )
            if resultado_debito.status_code != 200:
                print(f'ERRO AO BUSCAR O DEBITO: {resultado_debito.text}')
                continue
            debito = resultado_debito.json()
            situacao = debito.get("situacao").get("valor")
            if situacao in ["CANCELADA", "INSCRITA", "PAGA"]:
                continue

            debito["idguia_sonner"] = str(row[2])


            json_debitos.append(debito)

        except Exception as e:
            print(f'NÃO FOI POSSÍVEL OBTER OS DADOS DO DEBITO:\n{e}')
            continue
    for debito in json_debitos:
        utils.execute_query("""INSERT INTO cancelamento (guia_iss_govdigital_id, situacao, id_lote, json_debito)
        VALUES (%s, %s, %s, %s);""", (debito["idguia_sonner"], "AGUARDANDO_ENVIO", None, json.dumps(debito)))

        utils.execute_query("""UPDATE public.guia_iss_govdigital_canc
        SET grp_processado=1
        WHERE idguia=%s;""", (debito["idguia_sonner"],))


def envia_cancelamento(cancelamento: str) -> Response:
    cancelamento_id = cancelamento["id"]
    try:
        return request(url=os.getenv("API_TERCEIRO_URL_BASE") + "/lancamentos/"+ str(cancelamento_id) + "/cancelar",
                       method="POST",
                       headers={"user-access": os.getenv("API_TERCEIRO_USER_ACCESS"),
                                "Authorization": 'Bearer ' + os.getenv("API_TERCEIRO_AUTHORIZATION")})
    except Exception as e:
        print(f'[ATENÇÃO]ERRO NA FUNÇÃO envia_cancelancamento, VERIFIQUE O LOG DE ERROS:\n{e}')


def executa_cancelamento():
    print("Buscando guias canceláveis...")
    buscar_guias_cancelaveis()
    print("Buscou guias cancelaveis.")
    cancelamentos = utils.fetch_results("""SELECT id,json_debito FROM cancelamento where situacao = 'AGUARDANDO_ENVIO'""")

    for cancelamento in cancelamentos:
        retorno = envia_cancelamento(cancelamento[1])
        try:
            mensagem_retorno = retorno.json()
            idGerado = mensagem_retorno.get("idLote")
        except Exception as e:
            idGerado = None
            mensagem_retorno = retorno.text

        situacao = "SUCESSO"
        if retorno.status_code != 200:
            situacao = "ERRO"

        utils.execute_query(
            """UPDATE cancelamento set json_debito = %s,situacao = %s,id_lote = %s, json_retorno = %s where id = %s""",
            (json.dumps(cancelamento[1]), situacao, idGerado, json.dumps(mensagem_retorno), cancelamento[0]))