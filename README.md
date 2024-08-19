
# Manual de Deploy - Projeto Integração DB Lagoa Santa

Este manual descreve os passos necessários para fazer o deploy do projeto "Integracao DB Lagoa Santa" em um servidor Ubuntu utilizando Docker.

## Pré-requisitos

1. **Servidor Ubuntu**:
   - Certifique-se de que o servidor esteja rodando Ubuntu 20.04 LTS ou superior.

2. **Acesso SSH**:
   - Acesso ao servidor via SSH com privilégios de root ou sudo.

3. **Git**:
   - Git instalado no servidor para clonar o repositório.

4. **Docker e Docker Compose**:
   - Docker e Docker Compose instalados no servidor.

## Passos para o Deploy

### 1. Atualizar o sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Git

```bash
sudo apt install git -y
```

### 3. Instalar Docker

```bash
sudo apt install docker.io -y
```

### 4. Instalar Docker Compose

```bash
sudo apt install docker-compose -y
```

### 5. Clonar o Repositório

```bash
git clone https://github.com/Mateuslh/integracao_db_lagoa_santa.git
cd integracao_db_lagoa_santa
```

### 6. Configurar Variáveis de Ambiente

Edite o arquivo `.env` na raiz do projeto para incluir as variáveis necessárias. 

### 7. Configurar Rotas DNS

Crie ou edite o arquivo `daemon.json` do Docker para configurar as rotas DNS:

```bash
sudo nano /etc/docker/daemon.json
```

Adicione as seguintes configurações:

```json
{
  "dns": ["8.8.8.8", "8.8.4.4"]
}
```

Reinicie o Docker para aplicar as mudanças:

```bash
sudo systemctl restart docker
```

### 8. Executar o Docker Compose

Para subir os containers necessários para a aplicação, execute:

```bash
docker-compose up -d
```

Este comando irá baixar as imagens necessárias, construir os containers e iniciá-los em segundo plano.

### 9. Verificar Status dos Containers

Para verificar se todos os containers estão rodando corretamente, use:

```bash
docker-compose ps
```

### 10. Logs

Para visualizar os logs dos containers:

```bash
docker-compose logs -f
```

## Conclusão

Após seguir estes passos, o deploy do projeto "Integracao DB Lagoa Santa" estará concluído, e a aplicação estará rodando em containers Docker configurados no servidor Ubuntu.
