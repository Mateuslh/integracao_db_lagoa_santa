FROM python:3.12

WORKDIR /app

# Copie todos os arquivos para o diretório de trabalho
COPY . .

# Instale as dependências
RUN pip install --no-cache-dir -r requirements.txt

