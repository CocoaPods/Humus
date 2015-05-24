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

1. `bundle exec rake db:test:dump`
2. `bundle exec rake`