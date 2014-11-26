Humus
=====

Handles database migrations and states for all CP web projects.

Run Migration
-------------

1. Test the migrations vigorously locally.
2. Push the code to Heroku: `git push heroku master`.
3. Run the migrations: `heroku run bundle exec rake db:migrate`