#!/bin/bash


docker run -d --name kafka --env KAFKA_HEAP_OPTS="-Xmx256M -Xms128M" --env ADVERTISED_HOST=kafka --env ADVERTISED_PORT=9092 spotify/kafka

docker run -d -p 9200:9200 --env KAFKA_HEAP_OPTS="-Xmx256M -Xms128M" --name es elasticsearch:2.0 -Des.network.host=es

docker run -d --name models -p 8001:8000 -v /vagrant/ISA_code/models_server_code:/app --link mysql:db_host tp33/django:1.1 /bin/bash -c "python manage.py migrate; mod_wsgi-express start-server --reload-on-changes models_server_code/wsgi.py"

docker run -d --name exp -p 8002:8000 -v /vagrant/ISA_code/exp_server_code:/app --link models:models_host --link kafka:kafka --link es:es tp33/django:1.1 mod_wsgi-express start-server --reload-on-changes exp_server_code/wsgi.py

docker run -d --name web -p 8003:8000 -v /vagrant/ISA_code/web_frontend_server_code:/app --link exp:exp_host tp33/django:1.1 mod_wsgi-express start-server --reload-on-changes web_frontend_server_code/wsgi.py

docker run -d --name batch --env KAFKA_HEAP_OPTS="-Xmx256M -Xms128M" --link kafka:kafka --link es:es zeizyy/isa_batch python ISA_batch/batch.py

sleep 5

docker start batch