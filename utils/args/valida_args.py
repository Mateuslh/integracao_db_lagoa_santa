import argparse
import os


def validar_args():
    parser = argparse.ArgumentParser(description="A aplicação de integração de dados é projetada para manter um banco"
                                                 " de dados PostgreSQL atualizado com dados recebidos periodicamente."
                                                 " A aplicação segue um padrão de alimentação contínua e realiza "
                                                 "operações de sincronização em intervalos específicos, garantindo que "
                                                 "o banco de dados espelhe com precisão as alterações e novos registros")

    parser.add_argument("-p", "--periodico", action="store_true", help="Realiza uma inserção periodica")
    parser.add_argument("-c", "--carga", action="store_true", help="Reseta a base atual, e realiza uma"
                                                                   " sincronização.")
    parser.add_argument("-i", "--iniciar", action="store_true", help="Ignorar todas os scripts executados "
                                                                     "até o momento")

    args = parser.parse_args()
    if args.periodico and args.carga:
        raise Exception("NÃO É SUPORTADO TAG -c e -p simultaneamente,\n"
                        "PARA CARGA INICIAL UTILIZE -i, PARA CARGA INICIAL UTILIZE -c, PARA CARGA PERIODICA UTILIZE -p")

    if args.iniciar:
        print("Excutando execução de reset dos artefatos.")
        os.environ["INIT"] = "true"

    if args.periodico:
        print("Executando a sincronização periodica.")
        os.environ["TIPO_EXECUCAO"] = "periodico"
    elif args.carga:
        print("Executando a sincronização para espelhamento.")
        os.environ["TIPO_EXECUCAO"] = "carga"

    print('-' * 25)
