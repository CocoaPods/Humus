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

Run Migrations in Production
----------------------------

First of all, be super careful.

Add the remote once:

a. `heroku git:remote -a cocoapods-humus-service`

Ask for permissions if you need access.

Then:

1. Test the migrations vigorously locally.
2. Push the code to Heroku: `git push heroku master`.
3. Run the migrations: `heroku run bundle exec rake db:migrate`

Answer all verification questions.

If it goes badly wrong, we have daily automated backups in place.
See the Trunk Heroku app for infos.

Running tests
-------------

You need to have access (be on the core team).

1. `bundle exec rake db:test:dump`
2. `bundle exec rake`