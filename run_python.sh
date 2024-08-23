#!/bin/bash

echo "$(date) - Iniciando o script" >> /app/log.txt

while true; do
  echo "$(date) - Executando python3 main.py -p"
  python3 main.py -p
  sleep 450
done


