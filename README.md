# Braven Data Warehouse

## Dev Setup

### Data
Using docker, it's very easy to get the application up and running. We don't even need to worry about keeping database passwords out of the repo, because Docker will spin up a database that only this application has access to, on a private network.

First, we need to copy a couple of environment files in the app directory:

    cp .env.example .env
    cp .env.database.example .env.database

Again, you don't really need to change the database passwords in these files, so we're doing this mainly to conform to "best practices" for Rails apps in general. But if you do want to pick a different database password, make sure it matches in both files.

Now fire up and build the docker environment. This will create/launch the Rails app, as well as a PostgreSQL database server for the app to use:

    docker-compose up -d

This will take a while the first time, because Docker has to download a Ruby image and a PostgreSQL image and set them up. It will also install all the necessary Ruby gems that the app requires.

Now create the needed databases.

    docker-compose exec data-central bundle exec rake db:create db:schema:load db:seed

We've configured Docker to run our Rails app on port 3020, so go to http://localhost:3020 in your favorite browser. If everything's working correctly, you should be brought to a page which says "Welcome!" and has links to the database data. 

#### Seed Data

Be sure to get the CSV file of our postal codes, which is too large to include in the git repo:

https://drive.google.com/open?id=1uyhCoe7BB4mTfFa8vmcG9udln5VQ9d8v

Place it in the tmp directory of the application. Now load all of our default data:

    rake db:seed

This gives you industries, interests, majors, locations, and postal codes for free.

#### Dummy Data

In dev or staging environments, we may want a few people, contacts, etc to work with. Unlike the seed data above, 
this data is NOT meant for production. Therefore, it has a separate source file (dummies.rb) and rake task:

    rake db:dummies

This currently generates a number of people, with contact info. It uses our the factories from our test suite,
which have been updated to show more variety in names, emails, and addresses.

### Environment Variables

    DATABASE_HOST
    DATABASE_USERNAME
    DATABASE_PASSWORD
