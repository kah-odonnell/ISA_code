#!/bin/bash

docker run -d --name models -p 8001:8000 -v /home/zeizyy/projects/ISA_code/models_server_code:/app --link mysql:db_host tp33/django:devel mod_wsgi-express start-server --reload-on-changes models_server_code/wsgi.py 

docker run -d --name exp -p 8002:8000 -v /home/zeizyy/projects/ISA_code/exp_server_code:/app --link models:models_host tp33/django:devel mod_wsgi-express start-server --reload-on-changes exp_server_code/wsgi.py

docker run -d --name web -p 8003:8000 -v /home/zeizyy/projects/ISA_code/web_frontend_server_code:/app --link exp:exp_host tp33/django:devel mod_wsgi-express start-server --reload-on-changes web_frontend_server_code/wsgi.py



