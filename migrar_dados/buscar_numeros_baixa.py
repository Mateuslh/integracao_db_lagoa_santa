import os

from numpy import size
from requests import request

import utils
from utils import execute_query


def reserva_numeros_baixa():
    numeros_baixa = request(
        url=os.getenv("API_TERCEIRO_URL_BASE") + "/numeros-baixa/ISSQNMOVIM",
        method="POST",
        headers={
            "user-access": os.getenv("API_TERCEIRO_USER_ACCESS"),
            "Authorization": 'Bearer ' + os.getenv("API_TERCEIRO_AUTHORIZATION")
        }
    ).json()

    values = ', '.join([f'({baixa})' for baixa in numeros_baixa])

    sql = f'INSERT INTO numero_baixa (id) VALUES {values};'
    utils.execute_query(sql)


def get_numero_baixa():
    sql_disponiveis = """select id from numero_baixa where numero_baixa.usado is not true limit 1"""
    numeros_baixa_diponivel = utils.fetch_results(sql_disponiveis)

    if size(numeros_baixa_diponivel) == 0:
        reserva_numeros_baixa()
        numeros_baixa_diponivel = utils.fetch_results(sql_disponiveis)
    numero_baixa = numeros_baixa_diponivel[0][0]
    execute_query("""UPDATE numero_baixa
SET usado=true
WHERE id=%s;""",(numero_baixa,))
    return numero_baixa