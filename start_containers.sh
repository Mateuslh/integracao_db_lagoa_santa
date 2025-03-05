#!/bin/bash

# Start all containers in detached mode
docker compose up -d

# Wait a few seconds to ensure containers are up
sleep 5

# Execute commands inside the Python container
docker exec -it python_app bash -c '
  echo "$(date) - Iniciando o script" >> /app/log.txt
  while true; do
    echo "$(date) - Executando python3 main.py -p"
    python3 /app/main.py -p
    sleep 450
  done
'
