Humus
=====

Handles database migrations and states for all CP web projects.

Humus is the data ground on which we build beautiful trees, for example the cocoa palm.

Goals
-----

This project:

* handles the CocoaPods production DB state by managing trunk/metrics migrations.
* helps setup a local CocoaPods development/test DB.
* can pull snapshots from the production DB for testing purposes.

Getting a copy of the Test Database set up for using with CocoaPods web projects
--------------------------------------------------------------------------------

Set up the repo: 

```sh
git clone https://github.com/CocoaPods/Humus.git
cd Humus
bundle install
```

Create the DB for the development environment:

```sh
RACK_ENV=development bundle exec rake db:create
```

Update it to latest:

```sh
RACK_ENV=development bundle exec rake db:migrate
```

Dependencies
------------

Ubuntu:

If `bundle install` fails, then you probably need to install the following:

```sh
sudo apt-get install postgresql libpqdev postgresql-server-dev-9.6 
```

Run Migrations in Production
----------------------------

First of all, be super careful.

Add the remote once:

a. `heroku git:remote -a cocoapods-humus-service`

Ask for permissions if you need access.

Then:

1. Set the versions in `migrate.rb` to where you'd like them to be in production.
2. Test the migrations vigorously locally: `bundle exec rake db:migrate`.
3. Use automated tests. There is an migration spec example here: `spec/integration/delete_cascade_spec.rb`.
4. Verify that you are happy with the migration.
5. Push the code to Heroku: `git push heroku master`.
6. Consider making a manual backup on Heroku.
7. Run the migrations in production: `heroku run bundle exec rake db:migrate`
8. Verify that everything went well. If not, depending on the situation, consider:
  * Reverting to the backup.
  * Adding another migration.
9. If all went well: Congratulations!

Answer all verification questions.

If it goes badly wrong, we have daily automated backups in place.
See the Trunk Heroku app for infos.

Running tests
-------------

You need to have access (be on the core team).

1. List the available snapshots
```
bundle exec rake db:test:dump
trunk-201510021730-b154.dump
trunk-201709-11349-a857.dump
```

2. Provide the selected ID (omitting the `trunk-` prefix) to the same command
```
bundle exec rake db:test:dump[201510021730-b154]
```

3. `bundle exec rake`

Using Humus Snapshots for Integration Tests
-------------------------------------------

A Humus snapshot is just a sanitized Trunk DB Heroku snapshot (dump).
They allow you to write test that run against the actual prod DB.

1. Add the following to your project's `Gemfile`:

        gem 'cocoapods-humus', :require => false

2. Add the following Ruby code where you'd like to seed the DB:

        require 'cocoapods-humus'
        Humus.with_snapshot('201510021730-b154')

That snapshot identifier is the only one currently available (Dump from 17:30, Oct 2, 2015, from Heroku snapshot b154).
Note: When loading the DB, you may see some warnings.

Using Humus Snapshots for CI
----------------------------

See explanation in the last section.

1. Set up Humus snapshots for your tests as in the last section.
2. Add to the following to `.travis.yml`:

        sudo: false
        addons:
          postgresql: "9.4"
          apt:
            packages:
            - postgresql-server-dev-9.4
        env:
          secure: "MeyjQ3gyQBQhvTxHC/HQSUG2LmvGdeD9aizM+pNxF8ae+0Rf4yPXKhJdQW8iNnl1QnQdNEHv/6y4mitR2UJ4wllSW/kvk6SBPQShXSmvrQIAX//R8hR4vZzRnLkEZmfL8al1ZazPABOeinQg6vEL1+AYjOLk2UAfHvcyUlUTcpM="

3. Replace the `secure` text above (insert S3 access keys) with the result of `travis encrypt` (http://docs.travis-ci.com/user/environment-variables/#Encrypted-Variables):

        travis encrypt 'DUMP_ACCESS_KEY_ID=... DUMP_SECRET_ACCESS_KEY=...'

4. Push the project. Check Travis.

Generating a sanitized Trunk DB Heroku snapshot
-----------------------------------------------

So you've added a new table to the DB and you'd like it included in the dump.
That is, the old dump is not good enough anymore.

1. Create a new Heroku snapshot
    ```
    heroku pg:backups:capture --app cocoapods-trunk-service
    ```
2. Download that dump.
    ```
    heroku pg:backups:download --app cocoapods-trunk-service
    ```
3. Load it into a DB.
4. Run this SQL on that DB to sanitize the Trunk data:

        -- Add helper function.
        create or replace function random_string(length integer) returns text as
        $$
        declare
          chars text[] := '{A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z}';
          result text := '';
          i integer := 0;
        begin
          if length < 0 then
            raise exception 'Given length cannot be less than 0';
          end if;
          for i in 1..length loop
            result := result || chars[1+random()*(array_length(chars, 1)-1)];
          end loop;
          return result;
        end;
        $$ language plpgsql;
        
        -- Anonymize owners.
        UPDATE owners
        SET
        	name = concat(random_string(1), lower(random_string(5)), ' ', random_string(1), lower(random_string(7))),
        	email = lower(concat(random_string(15), '@', random_string(10), '.', random_string(3)));
        
        -- Empty sessions table.
        TRUNCATE TABLE sessions;

5. Export the Trunk DB data by running (`-Fc` compresses):

        pg_dump -Fc dbname > data.dump

6. Rename the `data.dump` file to:

        trunk-201501021234-bXXX.dump (trunk-%Y%m%d%H%M-<Heroku manual dump name>.dump)

7. Upload to our S3 DB dump storage (Only Florian knows how, currently - will update this).
