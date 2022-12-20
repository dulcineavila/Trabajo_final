from django.shortcuts import render, redirect
from django.http import HttpResponse
from .models import Post
from .forms import Postform

# Create your views here

def Inicio(request):
    return render(request,'index.html')

def Nosotros(request):
    return render(request,'nosotros.html')

def Publicaciones(request):
    post=Post.objects.all()
    return render(request,'post/publicaciones.html', {'Posteos':post})

def Sumate(request):
    return render(request,'sumate.html')

def Crear_posteo(request):
    formulario = Postform(request.POST or None, request.FILES or None)
    if(formulario.is_valid()):
        formulario.save()
        return redirect('publicaciones')
    return render(request, "Post/crear.html", {'formulario': formulario})

def Editar_posteo(request,title):
    post = Post.objects.get(title=title)
    formulario = Postform(request.POST or None, request.FILES or None, instance=post)
    if(formulario.is_valid() and request.POST):
        formulario.save()
        return redirect('publicaciones')
    return render(request,'Post/editar.html', {'formulario':formulario})

def Borrar_posteo(request,tittle):
    post = Post.objects.get(tittle=tittle)
    post.delete()
    return redirect('publicaiones')

