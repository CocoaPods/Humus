Humus
=====

Handles database migrations and states for all CP web projects.

Humus is the data ground on which we build beautiful trees, for example the cocoa palm.

Run Migration
-------------

a. `heroku git:remote -a cocoapods-humus-service`

1. Test the migrations vigorously locally.
2. Push the code to Heroku: `git push heroku master`.
3. Run the migrations: `heroku run bundle exec rake db:migrate`