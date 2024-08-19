import os
import utils
import zipfile

def extrai_arquivos():
    print("Extraindo arquivos do banco...")
    contador = 0
    arquivos = utils.fetch_results(query='''SELECT protocolo_id FROM protocolo WHERE situacao = 'AGUARDANDO_EXTRACAO' AND tipo_execucao = %s''',
                                   params=[os.getenv("TIPO_EXECUCAO")])

    pasta_zip = os.path.join(os.getenv("DIRETORIO_FILES"),'zip')
    pasta_arquivos = os.path.join(os.getenv("DIRETORIO_FILES"),'arquivos')

    if not os.path.exists(pasta_arquivos):
        os.makedirs(pasta_arquivos)

    for protocolo in arquivos:

        protocolo_id = protocolo[0]
        nome_arquivo_zip = f"{protocolo_id}.zip"

        caminho_pasta = os.path.join(pasta_arquivos, protocolo_id)
        if not os.path.exists(caminho_pasta):
            os.makedirs(caminho_pasta)

        caminho_zip = os.path.join(pasta_zip, nome_arquivo_zip)

        if os.path.exists(caminho_zip):
            try:
                with zipfile.ZipFile(caminho_zip, 'r') as zip_ref:
                    zip_ref.extractall(caminho_pasta)
                os.remove(caminho_zip)
                utils.update_sit_protocolo(protocolo=protocolo_id,situacao='AGUARDANDO_SINC_DB')
                contador += 1
            except Exception as e:
                print(f"Falha ao extrair o arquivo {nome_arquivo_zip}: {e}")
        else:
            print(f"O arquivo {nome_arquivo_zip} não foi encontrado.")

    print(f'{contador} arquivos extraidos com sucesso!')