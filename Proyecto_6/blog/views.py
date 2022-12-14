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
        return redirect('posteos')
    return render(request, "Post/crear.html", {'formulario': formulario})

def Editar_posteo(request,slug):
    post = Post.objects.get(slug=slug)
    formulario = Postform(request.POST or None, request.FILES or None,instance=post)
    if(formulario.is_valid() and request.POST):
        formulario.save()
        return redirect('posteos')
    return render(request,'Post/editar.html', {'formulario':formulario})

def Borrar_posteo(request,slug):
    post = Post.objects.get(slug=slug)
    post.delete()
    return redirect('posteos')


class Posteo(TemplateView):
    template_name = "posteos.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["post"] = Post.objects.all()
        return context
    



class PostDetail(DetailView):
    model = Post
    template_name = "postDetail.html"
    context_object_name='post'

    
    def get_context_data(self, **kwargs):
      context = super().get_context_data(**kwargs)
      post = Post.objects.filter(slug=self.kwargs.get('slug'))
      return context
    

