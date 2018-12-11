# Braven Data Warehouse

## Dev Setup

### Data


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
