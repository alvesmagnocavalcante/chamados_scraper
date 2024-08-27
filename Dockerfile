# Use uma imagem base que inclui Python 3.10
FROM python:3.10-slim

# Defina o diretório de trabalho
WORKDIR /app

# Instale as dependências do sistema e o Google Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Adicione a chave do repositório do Google e o repositório do Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable=114.0.5735.90-1

# Baixe e instale o ChromeDriver correspondente
RUN wget https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver_linux64.zip

# Crie e ative um ambiente virtual
RUN python -m venv /venv

# Copie os arquivos do projeto para o contêiner
COPY . .

# Ative o ambiente virtual e instale as dependências do Python
RUN /venv/bin/pip install --no-cache-dir -r requirements.txt

# Defina o PATH para incluir o diretório do ambiente virtual
ENV PATH="/venv/bin:$PATH"

# Exponha a porta do Django
EXPOSE 8000

# Comando para aplicar migrações e iniciar o servidor Django
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
