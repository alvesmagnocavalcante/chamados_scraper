# Use uma imagem base que inclui Python
FROM python:3.9-slim

# Defina o diretório de trabalho
WORKDIR /app

# Instale dependências necessárias e Google Chrome
RUN apt-get update \
    && apt-get install -y wget gnupg unzip \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
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
    && rm -rf /var/lib/apt/lists/*

# Instale o ChromeDriver
RUN wget -q -O chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip -d /usr/local/bin/ \
    && rm chromedriver_linux64.zip \
    && chmod +x /usr/local/bin/chromedriver

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Adicione o Chrome à PATH
ENV PATH="/usr/local/bin/chromedriver:${PATH}"

# Comando para aplicar migrações e iniciar o servidor Django
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver
