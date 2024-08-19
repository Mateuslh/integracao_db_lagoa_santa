import os

import requests

import utils


def coleta_resultados_protocolos():
    print('Fazendo download dos dados...')
    protocolos_a_baixar = utils.fetch_results(
        query='''SELECT protocolo_id FROM public.protocolo where situacao = \'AGUARDANDO_DOWNLOAD\' and tipo_execucao = %s''',params=[os.getenv("TIPO_EXECUCAO")])
    for protocolo in protocolos_a_baixar:
        coletar_dados(protocolo)
    print(f'{len(protocolos_a_baixar)} arquivos coletados.')
    print('-'*25)


def coletar_dados(protocolo_tuple):
    try:
        protocolo = protocolo_tuple[0]
        retorno = requests.request(method="GET",
                                   url=f'https://plataforma-execucoes.betha.cloud/v1/download/api/execucoes/{protocolo}/resultado')
        retorno.raise_for_status()
        pasta_zip = os.path.join(os.getenv('DIRETORIO_FILES'),'zip')
        caminho_zip_temp = os.path.join(pasta_zip, protocolo+'.zip')

        if not os.path.exists(pasta_zip):
            os.makedirs(pasta_zip)

        with open(caminho_zip_temp, 'wb') as file:
            file.write(retorno.content)
        utils.update_sit_protocolo(protocolo=protocolo,situacao="AGUARDANDO_EXTRACAO")
    except Exception as e:
        print(f'[ATENÇÃO]ERRO NA FUNÇÃO coletar_dados, VERIFIQUE O LOG DE ERROS:\n{e}')
        utils.update_sit_protocolo(protocolo=protocolo,situacao="ERRO_DOWNLOAD")
