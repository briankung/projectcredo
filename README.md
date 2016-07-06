# README

For initial set up:

1. Install docker, docker-machine, and docker-compose
    https://docs.docker.com/engine/installation/
2. `docker-compose build`
3. `docker-compose up`
4. `docker-compose run app rails db:migrate`
5. `echo $(docker-machine ip default)/16 > .env`

    This instruction won't work if you don't have `docker-machine`
