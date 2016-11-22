# README

Project Credo is a tool for curating, commenting on, and sharing lists of research papers.

If you've ever done research on how coffee affects your body, interventions or preventative measures for cancers, or how to build muscle mass most effectively, you're not alone...and now you can work together to research the questions that vex humanity.

It is a humble first step on what is hopefully a path towards greater scientific consensus among both academics and laypersons.

Project Credo is open-source by design, under a GPLv3 license.

## Development

### Requirements:

- Docker
- Internet connection

### Installation

1. Install docker: https://docs.docker.com/engine/installation/
1. `git clone https://github.com/briankung/projectcredo.git` (or your favorite protocol)
1. `cd` into the directory
1. `docker-compose build` whenever you add a gem - in this case, you'll be installing all of them
1. `docker-compose run app rails db:create db:schema:load db:migrate db:seed` - to create the database, load the schema, migrate any lingering migrations, and then seed with test data
1. `docker-compose up` to run the rails server

### Visiting the site locally

The site's address unfortunately depends on what system you're on. Linux and Mac OS seem to be fine mounting it at `localhost:3000`, but on Windows, we've needed to find the docker container's IP address in order to actually see the site. You may need to figure out what your docker container's IP address is.

### Contributing

Submit a pull request against the develop branch and fill out the Pull Request template.

### Reporting issues

Start a new issue and fill out the issues template as well as you can.
