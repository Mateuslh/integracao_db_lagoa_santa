FROM python:3.12

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

## Instala o cron e atualiza a lista de pacotes
#RUN apt-get update && apt-get install -y cron
#
## Copia o arquivo de configuração do cron para o diretório correto
#COPY crontab /etc/cron.d/my-cron-job
## Adiciona permissão para o arquivo do cron
#RUN chmod 0644 /etc/cron.d/my-cron-job
## Aplica a configuração do cron
#RUN crontab /etc/cron.d/my-cron-job
#
## Copia o script de entrada e adiciona permissão de execução
#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#
## Define o comando para iniciar o cron e o script de entrada
#CMD ["/bin/bash", "-c", "cron && /entrypoint.sh"]
