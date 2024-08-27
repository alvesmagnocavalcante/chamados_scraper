# Use uma imagem base que inclui Python
FROM python:3.9-slim

# Defina o diretório de trabalho
WORKDIR /app

# Instale as dependências do sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && apt-get clean

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Exponha a porta do Django
EXPOSE 8000

# Comando para aplicar migrações e iniciar o servidor Django
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
