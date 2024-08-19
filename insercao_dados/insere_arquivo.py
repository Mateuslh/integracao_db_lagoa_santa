import os

import pandas as pd

import utils


def insere_arquivos():
    protocolos = utils.fetch_results(query="SELECT protocolo_id FROM protocolo where situacao = 'AGUARDANDO_SINC_DB' "
                                           "and tipo_execucao = %s",
    params=[os.getenv("TIPO_EXECUCAO")])

    caminho = os.path.join(os.getenv("DIRETORIO_FILES"),"arquivos")
    for protocolo in protocolos:
        protocolo_id = protocolo[0]
        caminho_protocolo = os.path.join(caminho,protocolo_id)

        for arquivo in os.listdir(caminho_protocolo):
            caminho_arquivo = os.path.join(caminho_protocolo,arquivo)
            inserts = gerar_inserts_csv_como_string(caminho_arquivo)
            for insert in inserts:
                utils.execute_query(query=insert)
        utils.update_sit_protocolo(protocolo_id,'INSERIDO')
        print('-'*25)


import pandas as pd
import os

def gerar_inserts_csv_como_string(caminho_csv):
    df = pd.read_csv(caminho_csv, delimiter=os.getenv("CSV_DELIMITER"), engine='python')
    nome_tabela = caminho_csv.split("/")[-1].split(".")[0]

    print(f'Inserindo {df.shape[0]} registros na tabela {nome_tabela}...')

    comandos_insert = []

    for index, row in df.iterrows():
        colunas = ', '.join(df.columns)
        valores = []

        for val in row.values:
            if pd.isna(val):
                valores.append('NULL')
            else:
                val_str = str(val).replace("'", "''").replace("\\", "\\\\")
                valores.append(f"'{val_str}'")

        valores_str = ', '.join(valores)
        update_set = ', '.join([f"{col} = EXCLUDED.{col}" for col in df.columns if col != 'id'])

        comando_insert = f"""
        INSERT INTO {nome_tabela} ({colunas}) 
        VALUES ({valores_str}) 
        ON CONFLICT (id) 
        DO UPDATE SET {update_set};
        """
        comandos_insert.append(comando_insert.strip())

    return comandos_insert


    return comandos_insert