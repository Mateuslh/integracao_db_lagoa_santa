import os
from datetime import datetime, timedelta

from dotenv import load_dotenv

import utils

load_dotenv()

data_limite = datetime.now() - timedelta(days=30)

def buscar_resultados_scripts(ids_scripts, situacao):
    print("Buscando resultados de scripts...")
    registros = []
    for id_script in ids_scripts:
        registros += buscar_protocolos(id_script, situacao)
    print(f'{len(registros)} registros inseridos com sucesso.')
    print('-'*25)

def buscar_protocolos(idScript, situacao) -> list:
    protocolos_inseridos = []
    token_tela = utils.Token_tela(client_id=os.getenv('TOKEN_TELA_EXTENSOES_CLIENT_ID'),
                                  token=os.getenv('TOKEN_TELA_EXTENSOES_BASE'),
                                  scopes=[
                                      "campos-adicionais.suite",
                                      "contas-usuarios.suite",
                                      "dados.suite",
                                      "gerenciador-configuracoes.suite",
                                      "gerenciador-relatorios.suite",
                                      "gerenciador-scripts.suite",
                                      "licenses.suite",
                                      "modelo-dados.suite",
                                      "naturezas.suite",
                                      "notifications.suite",
                                      "quartz.suite",
                                      "sistema_interno",
                                      "user-accounts.suite"
                                  ],
                                  redirect_uri='https://scripts.plataforma.betha.cloud/auth-callback.html')

    retorno = utils.RequisicaoTela(authorization=token_tela,
                                   method="GET",
                                   url="https://plataforma-execucoes.betha.cloud/v1/api/execucoes",
                                   headers={
                                       'accept': 'application/json, text/plain, */*',
                                       'origin': 'https://scripts.plataforma.betha.cloud',
                                       'priority': 'u=1, i',
                                       'referer': 'https://scripts.plataforma.betha.cloud/',
                                       'user-access': os.getenv("TOKEN_TELA_USER_ACCESS"),
                                       'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36'
                                   },
                                   params={
                                       "filter": f' (artefato.id=\'{idScript}\' and artefato.tipo = \'SCRIPT\' )',
                                       "limit": os.getenv('REGISTROS_BUSCADOS_POR_SCRIPT')
                                   }).rodar()
    for protocolo in retorno.json()["content"]:
        iniciada_em = datetime.strptime(protocolo["iniciadaEm"], "%Y-%m-%dT%H:%M:%S.%f")
        if not protocolo_inserted(idScript, protocolo) and \
                protocolo["gerouResultado"] and \
                protocolo["concluida"] and \
                iniciada_em >= data_limite:
            insert_protocolo(protocolo, situacao)
            protocolos_inseridos.append(protocolo)
    return protocolos_inseridos



def insert_protocolo(protocolo, situacao):
    utils.execute_query(query='''INSERT INTO protocolo
(protocolo_id, situacao, script_id,tipo_execucao)
VALUES(%s, %s, %s, %s);''',
                        params=[protocolo['id'], situacao, protocolo['artefato']['id'],os.getenv("TIPO_EXECUCAO")])


def protocolo_inserted(idScript, protocolo):
    return 0 < len(utils.fetch_results(
        query='''SELECT protocolo_id FROM public.protocolo where script_id = %s and protocolo_id = %s''',
        params=(int(idScript), protocolo["id"])))


def reset_periodico(ids_scripts):
    buscar_resultados_scripts(ids_scripts,'IGNORAR')