from .base import *
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'blog',
        'USER': 'root',
        'PASSWORD': 'podypoc18',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}