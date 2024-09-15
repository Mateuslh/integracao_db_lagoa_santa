from dotenv import load_dotenv
import os

from utils import args

load_dotenv()

from colect import coleta_dados, insercao_dados
from migrar_dados.inserir_guias import insere_guias

args.validar_args()

ids_scripts_periodico = os.getenv("LISTA_SCRIPTS_CONSULTA_PERIODICA").split(",")
ids_scripts_carga = os.getenv("LISTA_SCRIPTS_CONSULTA_CARGA").split(",")


if os.getenv("INIT") == 'true':
    coleta_dados.reset_periodico(ids_scripts=ids_scripts_periodico)
    coleta_dados.reset_periodico(ids_scripts=ids_scripts_carga)

if os.getenv("TIPO_EXECUCAO") == 'periodico':
    coleta_dados.buscar_resultados_scripts(ids_scripts_periodico, 'AGUARDANDO_DOWNLOAD')
    coleta_dados.coleta_resultados_protocolos()

    insercao_dados.extrai_arquivos()
    insercao_dados.insere_arquivos()

    insere_guias()


if os.getenv("TIPO_EXECUCAO") == 'carga':
    pass

