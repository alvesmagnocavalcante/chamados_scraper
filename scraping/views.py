from django.shortcuts import render, redirect
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time

def index(request):
    if request.method == "POST":
        return redirect('realizar_scraping')
    return render(request, 'index.html')

def realizar_scraping(request):
    # Configuração do ChromeDriver
    chrome_options = Options()
    chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-gpu")  # Opcional, ajuda em ambientes com poucos recursos

    # Especificando o caminho para o ChromeDriver
    service = Service(executable_path='/usr/local/bin/chromedriver')  # Certifique-se de que o caminho esteja correto
    driver = webdriver.Chrome(service=service, options=chrome_options)

    try:
        url = "https://grupomateus.atlassian.net/servicedesk/customer/user/requests?page=1&statuses=open"
        driver.get(url)

        # Interagindo com a página de login
        login = driver.find_element(By.XPATH, '//*[@id="user-email"]')
        login.send_keys('antonio.acavalcante@grupomateus.com.br')
        driver.find_element(By.XPATH, '//*[@id="login-button"]/span').click()

        time.sleep(2)

        senha = driver.find_element(By.XPATH, '//*[@id="user-password"]')
        senha.send_keys('P@ssw0rd2024!')
        driver.find_element(By.ID, 'login-button').click()

        time.sleep(5)

        # Coletando os dados dos chamados
        chamados_data = []
        chamados = driver.find_elements(By.XPATH, "//*[@id='main']/div/div/section/div[5]/div/div/div/table/tbody/tr")

        for chamado in chamados:
            link_element = chamado.find_element(By.XPATH, ".//td[3]/div/a")
            resumo = link_element.text
            link = link_element.get_attribute('href')
            status = chamado.find_element(By.XPATH, ".//td[4]/div/div/span/span").text
            solicitante = chamado.find_element(By.XPATH, ".//td[6]/div").text
            data_criacao = chamado.find_element(By.XPATH, ".//td[7]/div").text
            data_atualizacao = chamado.find_element(By.XPATH, ".//td[8]/div").text
            responsavel = chamado.find_element(By.XPATH, ".//td[9]/div").text

            chamados_data.append({
                'resumo': resumo,
                'status': status,
                'solicitante': solicitante,
                'data_criacao': data_criacao,
                'data_atualizacao': data_atualizacao,
                'responsavel': responsavel,
                'link': link
            })

    finally:
        driver.quit()

    return render(request, 'resultados.html', {'chamados': chamados_data})
