#!/bin/bash
# This connects to the development database. The user and database name are in docker-compose.yml
docker-compose exec platformdb psql -U user
