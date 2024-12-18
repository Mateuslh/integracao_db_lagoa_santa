import json
import os

from requests import request, Response

import utils
from migrar_dados.buscar_numeros_baixa import get_numero_baixa
from models import Pessoa, Economico

def buscar_guias_cancelaveis():
    json_debitos = list()
    rows_guias = utils.fetch_results("""
    select a.num_cadastro, a.num_documento, a.idguia, b.id_gerado id_debito
    from guia_iss_govdigital_canc a
    left join lancamento b on a.idguia = b.guia_iss_govdigital_id""")
    for row in rows_guias:
        id_debito = row[3]
        try:
            resultado_debito = request(url=os.getenv("API_TERCEIRO_URL_BASE") + "/debitos/" + str(id_debito),
                           method="GET",
                           headers={"user-access": os.getenv("API_TERCEIRO_USER_ACCESS"),
                                    "Authorization": 'Bearer ' + os.getenv("API_TERCEIRO_AUTHORIZATION")},
                           )
            debito = resultado_debito.json()
            debito["idguia_sonner"] = row[2]
            situacao = debito.get("situacao").get("valor")
            if resultado_debito.status_code != 200:
                print(f'ERRO AO BUSCAR O DEBITO: {resultado_debito.text}')
                continue
            if situacao in ["CANCELADA", "INSCRITA", "PAGA"]:
                continue

            json_debitos.append(debito)

        except Exception as e:
            print(f'NÃO FOI POSSÍVEL OBTER OS DADOS DO DEBITO:\n{e}')
            continue

    for debito in json_debitos:
        utils.execute_query("""INSERT INTO cancelamento (guia_iss_govdigital_id, situacao, id_gerado, json_debito)
        VALUES (%s, %s, %s, %s);""", (debito["idguia_sonner"], "AGUARDANDO_ENVIO", None, json.dumps(debito)))

        utils.execute_query("""UPDATE public.guia_iss_govdigital_canc
        SET grp_processado=1
        WHERE idguia=%s;""", (debito["idguia_sonner"],))

def envia_cancelamento(cancelamento: str) -> Response:
    cancelamento_body = {
        "idIntegracao": "INTEGRACAO_NOTA_LS_"+cancelamento["id"],
        "guias": {
            "idGerado": {
                "id": cancelamento["id_debito"]
            },
            "situacao":  "CANCELADA"

        }
    }
    try:
        return request(url=os.getenv("API_MIGRACAO_URL_BASE") + "/guias",
                       method="PATCH",
                       headers={"Authorization": 'Bearer ' + os.getenv("TOKEN_MIGRACAO_INTEGRACAO")},
                       json=cancelamento_body)
    except Exception as e:
        print(f'[ATENÇÃO]ERRO NA FUNÇÃO envia_cancelamento, VERIFIQUE O LOG DE ERROS:\n{e}')

def executa_cancelamento():
    print("Buscando guias canceláveis...")
    buscar_guias_cancelaveis()
    cancelamentos = utils.fetch_results("""SELECT id,json_debito FROM cancelamento where situacao = 'AGUARDANDO_ENVIO'""")

    for cancelamento in cancelamentos:
        retorno = envia_cancelamento(cancelamento[1])
        try:
            mensagem_retorno = retorno.json()
            idGerado = mensagem_retorno.get("id")
        except Exception as e:
            idGerado = None
            mensagem_retorno = retorno.text

        situacao = "SUCESSO"
        if retorno.status_code != 200:
            situacao = "ERRO"

        utils.execute_query(
            """UPDATE cancelamento set json_debito = %s,situacao = %s,id_gerado = %s, json_retorno = %s where id = %s""",
            (json.dumps(cancelamento[1]), situacao, idGerado, json.dumps(mensagem_retorno), cancelamento[0]))