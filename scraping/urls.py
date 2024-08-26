# scraping/urls.py
from django.urls import path
from .views import index, realizar_scraping

urlpatterns = [
    path('', index, name='index'),
    path('scraping/', realizar_scraping, name='realizar_scraping'),
]
