from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.views.generic import TemplateView, DetailView
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

def Borrar_posteo(request,title):
    post = Post.objects.get(title=title)
    post.delete()
    return redirect('publicaciones')


class Posteo(TemplateView):
    template_name = "blog/index.html"

    def get_context_data(self, **kwargs):
        context = super(Post, self).get_context_data(**kwargs)
        context["post"] = Post.objects.all()
        return context
    



class PostDetail(DetailView):
    model = Post
    template_name = "blog/detail.html"
    context_object_name='post'

    
    def get_context_data(self, **kwargs):
        context = super(Post, self).get_context_data(**kwargs)
        post = Post.objects.filter(slug=self.kwargs.get('slug'))
        return context
    


