# Use a imagem base que inclui Python
FROM python:3.9-slim

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale as dependências necessárias
RUN apt-get update \
    && apt-get install -y wget unzip \
    && wget -q -O chromedriver.zip https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip \
    && unzip chromedriver.zip -d /usr/local/bin/ \
    && rm chromedriver.zip \
    && apt-get install -y \
       libglib2.0-0 \
       libnss3 \
       libx11-xcb1 \
       libxkbcommon0 \
       libxcomposite1 \
       libxdamage1 \
       libxrandr2 \
       libatspi2.0-0 \
       fonts-liberation \
       libappindicator3-1 \
       xdg-utils \
       --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instale as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Adicione o Chrome à PATH
ENV PATH="/usr/local/bin/chromedriver:${PATH}"

# Comando para aplicar migrações e iniciar o servidor Django
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
