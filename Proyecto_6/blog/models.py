from django.db import models
from django.conf import settings
from django.utils import timezone
# Create your models here.

class   Post (models.Model):
    autor = models.ForeignKey (settings.AUTH_USER_MODEL, on_delete=models.CASCADE,null=True)
    title = models.CharField (max_length=200)
    description = models.TextField(null=True)
    fecha_creacion= models.DateTimeField (default= timezone.now)
    fecha_publicacion = models.DateTimeField (blank=True, null=True)

    def publicar(self):
        self.fecha_publicacion = timezone.now()
        self.save()
    
    def __str__(self):
        return self.title
