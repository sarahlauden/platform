# Braven Platform

[![Codacy Health Badge](https://api.codacy.com/project/badge/Grade/f800f0c485164dacb4b493d8acfb19e6)](https://www.codacy.com/manual/bebraven/platform)
[![Codacy Coverage Badge](https://api.codacy.com/project/badge/Coverage/f800f0c485164dacb4b493d8acfb19e6)](https://www.codacy.com/manual/bebraven/platform)

This is the Braven Platform!

## Initial setup

First, we need to copy a couple of environment files in the app directory:

    cp .env.example .env
    cp .env.database.example .env.database

Be sure to set the `SSO_URL` variable in `.env` to point to whatever CAS SSO server you're using.

You don't really need to change the database passwords in these files, so we're doing this mainly to conform to "best
practices" for Rails apps in general. But if you do want to pick a different database password, make sure it matches in
both files.

Now fire up and build the docker environment. This will create/launch the Rails app, as well as a PostgreSQL database
server for the app to use:

    docker-compose up -d

This will take a while the first time, because Docker has to download a Ruby image and a PostgreSQL image and set them
up. It will also install all the necessary Ruby gems and JavaScript libraries the app requires.

Now create the needed databases:

    docker-compose exec platformweb bundle exec rake db:create db:schema:load db:migrate db:seed

We've configured Docker to run our Rails app on port 3020, so go to http://localhost:3020 in your favorite browser. If
everything's working correctly, you should be brought to the app's homepage.

If you have a `127.0.0.1   platformweb` entry in your `/etc/hosts` file, and are using the [nginx-dev
container](https://github.com/beyond-z/nginx-dev), you can also access the Platform app via http://platformweb.

### Dummy Data

In dev or staging environments, we may want a few people, contacts, etc to work with. Unlike the seed data above, 
this data is NOT meant for production. Therefore, it has a separate source file (db/dummies.rb) and rake task:

    rake db:dummies

This currently generates a number of people, with contact info. It uses our the factories from our test suite,
which have been updated to show more variety in names, emails, and addresses.

## Making changes

The app should automatically pick up any changes you make and live-reload in your browser. If for some reason you need
to rebuild the container (e.g. you added a `gem` dependency), you can do so in two ways - with or without the docker
cache.

With cache (recommended):

    docker-compose down
    docker-compose build

Without cache (slow! usually not necessary):

    docker-compose down -v --rmi all --remove-orphans  # deletes all container data!
    docker-compose build --force-rm --no-cache

In rare cases, you may need to bypass docker-compose and use docker directly to remove all volumes:

    docker volume rm platform_db-platform

If you change JavaScript dependencies, you may need to run `yarn` in the container:

    docker-compose down
    docker-compose run platformweb yarn install --check-files

In all cases, to bring the container back up after a rebuild, run:

    docker-compose up -d

### Project structure

This app is built with React and Rails. Generally speaking, developers will spend the most time in the Rails code
(models, views, controllers, and libs/helpers) and React components; designers will spend the most time in the React
components (HTML/JS/JSX) and CSS.

Rails views (ERB; these load the React components and handle backend API pages):

    app/views/layouts/application.html.erb
    app/views/*.erb

Rails models (database):

    app/models/*.rb

Rails controllers (business logic):

    app/controllers/*.rb

Rails routes:

    config/routes.rb

React components (JS/JSX/HTML):

    app/javascript/components/*/

React entrypoint (load and initialize JS dependencies):

    app/javascript/packs/platform.js

Stylesheets (CSS/SCSS):

    app/assets/stylesheets/*

Tests:

    spec/*

### Troubleshooting

If something isn't working, you can watch the docker logs live with:

    docker-compose logs -f

Or search through them with e.g.:

    docker-compose logs | grep "ERROR_I_WANT_TO_SEE"

### Accessibility testing

This project includes [axe](https://www.deque.com/axe/) in development, for live, in-browser accessibility reporting.
Open your browser's console to view axe reports.
