from django.urls import path
from . import views
from .views import PostDetail,Posteo
from django.contrib.auth import views as auth_views

urlpatterns = [
    path('',views.Inicio,name='inicio'),
    path('nosotros',views.Nosotros,name='nosotros'),
    path('sumate',views.Sumate,name='sumate'),
    path('publicaciones',views.Publicaciones,name='publicaciones'),
    path('posteos/crear',views.Crear_posteo,name='Cpost'),
    path("posteos/editar/<slug:slug>", views.Editar_posteo,name='Epost'),
    path("eliminar/<slug:slug>", views.Borrar_posteo,name='Bpost'),
    path('login', auth_views.LoginView.as_view(template_name='login.html') , name='login'),
    path('logout', auth_views.logout_then_login, name='logout'),
    path('<slug:slug>/', PostDetail.as_view(), name='postdetail'),
    path('posteos',Posteo.as_view(), name='posteos'),
]