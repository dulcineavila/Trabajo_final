from django.contrib import admin
#from .models import Post
from . import models

#admin.site.register(Post)
# Register your models here.
@admin.register(models.Post)
class AuthorAdmin(admin.ModelAdmin):
  #list_display=('title', 'status', 'autor', 'slug')
  prepopulated_fields = {'slug': ('title',),}
