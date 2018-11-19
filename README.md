# Braven Data Warehouse

## Dev Setup

### Data

Be sure to get the CSV file of our postal codes, which is too large to include in the git repo:

https://drive.google.com/open?id=1uyhCoe7BB4mTfFa8vmcG9udln5VQ9d8v

Place it in the tmp directory of the application. Now load all of our default data:

    rake db:seed

This gives you industries, interests, majors, locations, and postal codes for free.

### Environment Variables

    DATABASE_HOST
    DATABASE_USERNAME
    DATABASE_PASSWORD
