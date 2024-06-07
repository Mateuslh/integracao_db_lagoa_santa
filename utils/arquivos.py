import shutil


def deleta_pasta(caminho_pasta):
    try:
        shutil.rmtree(caminho_pasta)
    except Exception as e:
        print(f"Erro ao deletar a pasta '{caminho_pasta}': {e}")
