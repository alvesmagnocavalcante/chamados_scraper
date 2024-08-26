# scraping/models.py
from django.db import models

class Chamado(models.Model):
    resumo = models.CharField(max_length=255)
    status = models.CharField(max_length=100)
    solicitante = models.CharField(max_length=100)
    data_criacao = models.CharField(max_length=100)
    data_atualizacao = models.CharField(max_length=100)
    responsavel = models.CharField(max_length=100)
    link = models.URLField()

    def __str__(self):
        return self.resumo
