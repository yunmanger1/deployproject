import os
import sys

def f(s, *args, **kwargs):
    try:
        return s.format(*args, **kwargs)
    except:
        return s, " ".join(args), " ".join([v for k, v in kwargs.items()])

def echo(*args, **kwargs):
    print f(*args, **kwargs)

def _c(*args, **kwargs):
    return os.system(f(*args, **kwargs))

WORK_ROOT = os.path.abspath(os.path.dirname(os.path.dirname(__file__)))

echo(WORK_ROOT)

uwsgi_pack = 'uwsgi-0.9.7.2'
nginx_pack = 'nginx-0.7.65'
pcre_pack = 'pcre-8.12'

_e = os.path.exists

