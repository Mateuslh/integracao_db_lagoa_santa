import json
import os

from requests import request, Response

import utils
from migrar_dados.buscar_numeros_baixa import get_numero_baixa
from models import Pessoa, Economico
from models.guia import Guia


def insere_observacoes():
    print("Inserindo observações...")
    lancamentos = utils.fetch_results("""SELECT id,guia_iss_govdigital_id,id_gerado,nro_baixa FROM lancamento where obs_enviada is null""")

    for lancamento in lancamentos:
        observacao = lancamentos = utils.fetch_results(
            """SELECT id,cod_barras FROM guia_iss_govdigital where id = %s""",(lancamento[1]))[1][-17:]
        retorno = envia_observacoes({"observacao":observacao,"nro_baixa":lancamento[3]})

        try:
            mensagem_retorno = retorno.json()
        except Exception as e:
            mensagem_retorno = retorno.text

        situacao = f"SUCESSO_OBS-${mensagem_retorno}"
        if retorno.status_code != 200:
            situacao = "SUCESSO"


        utils.execute_query(
            """UPDATE lancamento set obs_enviada = %s where id = %s""",
            (situacao, lancamento[0]))


def envia_observacoes(lancamento: dict):
    obsBody = {
        "idIntegracao": "INTEGRACAO_NOTA_LS_" + str(cancelamento["id"]),
        "obsNumerosBaixas": {
            "observacao":lancamento["observacao"],
            "nroBaixa": lancamento["nro_baixa"]
        }
    }
    try:
        resposta = request(
            url=os.getenv("API_MIGRACAO_URL_BASE") + "/obsNumerosBaixas",
            method="POST",
            headers={
                "Authorization": 'Bearer ' + os.getenv("TOKEN_MIGRACAO_INTEGRACAO"),
                "Content-Type": "application/json; charset=utf-8"
            },
            json=obsBody
        )
        return resposta
    except Exception as e:
        print(f'[ATENÇÃO]ERRO NA FUNÇÃO envia_cancelamento, VERIFIQUE O LOG DE ERROS:\n{e}')