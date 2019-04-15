# Building a Rails App

**Commit** after each step!


## Getting started

* Get outside of this repo (we are starting from scratch)
* Get outside of that other repo (please don't be inside any repo)
* `rails new SchoolApp --database=postgresql`
* `cd SchoolApp`
* `rails db:create`

## Creating our models

#### A `Teacher` model

* Add a `Teacher` model: `rails g model Teacher`
  * Open up the newest migration in in the `db/migrate` directory.
  * Add a `name` and `photo` column
  ```ruby
    def change
      create_table :teachers do |t|
        t.string :name
        t.string :photo

        t.timestamps # updated_at and created_at
      end
    end
  ```
* `rails db:migrate`
* Add related files and **commit**
  * `app/models/teacher.rb` - Defines the `Teacher` class
  * `db/migrate/TIMESTAMP_create_teachers.rb` - Defines the migration that creates the `teachers` table
    * Do **not** edit this file after running `rails db:migrate` (until learn how to do this safely)
  * `db/schema.rb` includes all of your migrations.
    * **Never** edit this file.  **Always** commit it.

#### A `Course` model

* Add a `Course` Model - `rails g model Course`
  ```ruby
    def change
      create_table :courses do |t|
        t.string :name
        t.date :start_date
        t.date :end_date
        t.integer :teacher_id, index: true

        t.timestamps
      end
    end
  ```
* `rails db:migrate`
* **commit**

#### A `Student` model

* One more model - `rails g model Student`
  ```ruby
    def change
      create_table :students do |t|
        t.string :name
        t.integer :grade
        t.integer :age
        t.integer :course_id, index: true

        t.timestamps
      end
    end
  ```
* `rails db:migrate`
* **commit**

We did it!

Let's check out `db/schema.rb` to visualize our schema

## Adding relations

Let's go back to [Relations and Models](https://git.generalassemb.ly/wdi-nyc-garlic/LECTURE_U04_D06_Active-Record-101#ar-relations) part of the lecture and discuss these again.

You may use these as your relations.

## Seeding the data

Create teachers, courses, and students in your `db/seeds.rb` file.  Then run `rails db:seed`.

> If you change seed file and want to run it again you should run `rails db:reset` instead as this will delete all the entries before seeding

You may [use this](https://git.generalassemb.ly/wdi-nyc-garlic/LECTURE_U04_D06_Active-Record-101/blob/master/db/seeds.rb) as your seed data.

Save this as your `db/seeds.rb`

### Side note: adding gems

This seed file uses the `Faker` gem to generate random names. Add `gem 'faker'` to your `Gemfile` and then run `bundle install` so Rails can use this gem.


## Playing around with the relations

Let's jump back into the console (`rails c`) and make sure these relations are working as we expect!

```ruby
teacher = Teacher.find_by(name: 'Professor Ari') # => a Teacher !
teacher.courses # => courses !
teacher.students # => students !

student = Student.first
student.name # => the student's name
student.update(name: 'Stacey') # this is all it takes to update the db!!
```

## Adding routes, controllers, and views

#### Teachers

Assuming we only want `index` and `show` lets add this to our `config/routes.rb`

```ruby
resources :teachers, only: [:index, :show]
```

Let's add a controller for teachers: `rails g controller teachers`.

Open up `app/controllers`.  Let's add an `index` method

```ruby
def index
  @teachers = Teacher.all
end
```

And a view in `app/views/teachers/index.html.erb`.  Here is your chance to be creative.  Display a list of all the teachers however you want!

Start your server: `rails s` and go to `http://localhost:3000/teachers`

Now let's add a `show` method

```ruby
def show
  @teacher = Teacher.find(params[:id])
end
```

And add a view to `app/views/teachers/show.html.erb`

#### Courses

Now let's update our routes.  We can nest courses under teachers.

```ruby
resources :teachers, only: [:index, :show] do
  resources :courses, only: [:index, :show]
end
```

Let's add our controller: `rails g controller teachers`.

This time our controller is a little different because of the nesting.

Because of how routes `resources` work, we will get a `teacher_id` as a param.

Let's do a `rails routes` to visualize this.

```
teacher_courses GET  /teachers/:teacher_id/courses(.:format)     courses#index
 teacher_course GET  /teachers/:teacher_id/courses/:id(.:format) courses#show
       teachers GET  /teachers(.:format)                         teachers#index
        teacher GET  /teachers/:id(.:format)                     teachers#show
```

So in our controller:

```ruby
def index
  @teacher = Teacher.find(params[:teacher_id])
  @courses = @teacher.courses
end
```

Now that we have a hold of the `teacher` and their `courses` we can do whatever we want with the index view.

Tell us who the teacher is! List the courses!  Use that thing in your skull.

For `show` maybe we can start with something like this

```ruby
def show
  @course = Course.find(params[:id])
  @students = @course.students.order(:name)
  @teacher = @course.teacher # or find by params[:teacher_id]
end
```

Now we can add a `show` view.  What is the course name?  Can we list the students?  Who is the teacher?  This is a blank canvas and you are Frida Kahlo.


## Easy Bonus!

Add routes, controllers, and views for students!


## Advice

* Have exactly three tabs open in one terminal widow: bash, `rails s`, and `rails c`.  Have these three always open. Always one window.  Always in the same order.  And you will not get lost.
* Use [atom](https://atom.io/) or a text editor that will show you where your new and edited files are.
* When you do a thing, and that thing works, commit that thing.


## Rules

* Ask the docs.
* Do not get creative with the file structure (convention over configuration).
* Model names are singular.
* Controller names are (usually) plural.  Controller names that correspond to models are always plural.  (e.g `Teacher` and `TeachersController`)
* Use `rails g model`, and `rails g controller`
  * You will have a subtle typo in one of your file names if you add them yourself. Things will not work and you won't notice the typo.
* Do not edit files you are not supposed to edit.
  * `db/schema.rb` - **never** edit.
  * `db/migrations/*` - do not edit after running the migration.
