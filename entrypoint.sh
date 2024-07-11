#!/bin/bash
# Aplicar o crontab
crontab /etc/cron.d/my-cron-job

# Rodar o cron no primeiro plano
cron -f
