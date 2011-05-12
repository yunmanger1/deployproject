from django.core.management.base import BaseCommand
from django.conf import settings
from optparse import make_option
import os

_ = os.system

#PROJECT_ROOT = settings.PROJECT_ROOT
#def rel(*x):
#    return os.path.join(PROJECT_ROOT, *x)

#WORK_ROOT = rel("..","..")
#project_name=os.path.basename(PROJECT_ROOT)
#DEPLOY_ROOT = os.path.join(WORK_ROOT,"projects",project_name)

def deploy_media(conf):
    pass

class Command(BaseCommand):
    option_list = BaseCommand.option_list + (
        make_option('--conf', '-c', default='prod', dest='conf',
            help='Deploy configuration'),
    )
    help = ""

    def handle(self, *args, **options):
        conf = options.get('conf')
#        _("bash {0}/bin/copy-project.sh {1}".format(WORK_ROOT, project_name))
        if os.path.exists("etc"):
            _("rm etc")
        _("ln -s etcs/{0} etc".format(conf))
        deploy_media(conf)

