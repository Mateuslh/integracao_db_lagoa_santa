import json
import os

from requests import request, Response

import utils
from migrar_dados.buscar_numeros_baixa import get_numero_baixa
from models import Pessoa, Economico
from models.guia import Guia

def buscar_guias():
    rows_guias = utils.fetch_results("""
select g.*,c.codigo as c_codigo,c.id as c_id,e.codigo as e_codigo,e.id as e_id
    from guia_iss_govdigital g
    join economico e on e.codigo::bigint = g.num_cadastro::bigint
    join contribuinte c on c.id = e.contribuinte_id 
    where g.processado = false""")
    for row in rows_guias:
        guia = Guia.from_row(row)
        lancamento = guia.toLancamento()
        lancamento.pessoa = Pessoa(id=row["c_id"], codigo=row["c_codigo"])
        lancamento.economico = Economico(id=row["e_id"], codigo=row["e_codigo"])
        if row[20] == 'Tomador':lancamento.chaveLancamento = 'ISSRETIDO'
        else :lancamento.chaveLancamento = "ISSQNMOVIM"
        numero_baixa = get_numero_baixa()
        lancamento.nroBaixa = numero_baixa

        utils.execute_query("""INSERT INTO lancamento (guia_iss_govdigital_id, situacao, id_gerado, json_enviado)
VALUES (%s, %s, %s, %s);""", (row["id"], "AGUARDANDO_ENVIO", None, lancamento.to_json()))

        utils.execute_query("""UPDATE public.guia_iss_govdigital
SET  processado=TRUE
WHERE id=%s;""", (row[0],))


def envia_lancamento(lancamento: str) -> Response:
    try:
        print(json.dumps(lancamento))
        return request(url=os.getenv("API_TERCEIRO_URL_BASE") + "/lancamentos",
                       method="POST",
                       headers={"user-access": os.getenv("API_TERCEIRO_USER_ACCESS"),
                                "Authorization": 'Bearer ' + os.getenv("API_TERCEIRO_AUTHORIZATION")},
                       json=lancamento)
    except Exception as e:
        print(f'[ATENÇÃO]ERRO NA FUNÇÃO envia_lancamento, VERIFIQUE O LOG DE ERROS:\n{e}')


def insere_guias():


    buscar_guias()
    lancamentos = utils.fetch_results("""SELECT id,json_enviado FROM lancamento where situacao = 'AGUARDANDO_ENVIO'""")

    for lancamento in lancamentos:
        retorno = envia_lancamento(lancamento[1])
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
            """UPDATE lancamento set json_enviado = %s,situacao = %s,id_gerado = %s, json_retorno = %s where id = %s""",
            (json.dumps(lancamento[1]), situacao, idGerado, json.dumps(mensagem_retorno), lancamento[0]))
