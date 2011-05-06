# Create your views here.
from django.http import HttpResponse, Http404
import django

def home(request):
    return HttpResponse("Hello world! {0}".format(django.__file__))

def error(request):
    pass
