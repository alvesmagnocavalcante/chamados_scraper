# Use a imagem oficial do Python como base
FROM python:3.12-slim

# Instale as dependências necessárias para o Chrome e o ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    libasound2 \
    libpango1.0-0 \
    libpangocairo-1.0-0 \
    libpangoft2-1.0-0 \
    libgdk-pixbuf2.0-0 \
    libcups2 \
    libxss1 \
    libnspr4 \
    libdbus-1-3 \
    libxt6 \
    libxmu6 \
    libxpm4 \
    libgconf-2-4 \
    libxkbcommon-x11-0 \
    libxkbfile1 \
    libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Adicione a chave GPG do repositório do Google Chrome
RUN curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Adicione o repositório do Google Chrome
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list

# Instale o Google Chrome
RUN apt-get update && apt-get install -y google-chrome-stable

# Baixe e instale o ChromeDriver
RUN CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copia o arquivo de requisitos para o diretório de trabalho
COPY requirements.txt .

# Instala as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia o código do projeto para o diretório de trabalho no contêiner
COPY . .

# Coleta os arquivos estáticos para o Django
RUN python manage.py collectstatic --noinput || echo "Collectstatic failed"

# Executa as migrações do banco de dados
RUN python manage.py migrate

# Comando para iniciar o servidor Django
CMD ["gunicorn", "--bind", "0.0.0.0:8000"]
