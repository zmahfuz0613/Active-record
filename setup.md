## Set up

To use this app

* Run `bundle install` (or just `bundle`)
* Run `rails db:reset`
  - This will create the database, run migrations, and [seed the data](db/seeds.rb))
  - If the database already exists, it will drop it first
* To run the server:
  - In a new tab, run `rails server` (or just `rails s`)
* To open the console:
  - In a new tab, run `rails console` (or just `rails c`)
  - If you are having trouble loading the rails console, try `spring stop`.
