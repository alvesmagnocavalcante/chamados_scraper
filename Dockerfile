# Use uma imagem base que já inclui Chrome e ChromeDriver
FROM selenium/standalone-chrome:latest

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos do projeto para o contêiner
COPY . .

# Instale as dependências do Python
RUN pip install -r requirements.txt

# Defina as variáveis de ambiente, se necessário
# ENV DJANGO_SETTINGS_MODULE=myproject.settings

# Comando para aplicar migrações e iniciar o servidor Django
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
