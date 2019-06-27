# Building a Rails App

**Commit** after each step!


## Getting started

* Get outside of this repo (we are starting from scratch)
* `rails new school-app --database=postgresql`
* `cd school-app`
* `rails db:create`

## Creating our models

#### A `Teacher` model

* Add a `Teacher` model: `rails g model Teacher name:string photo:string`
  * Open up the newest migration in in the `db/migrate` directory.
  * Let's checkout the migration file before we migrate it. Notice a `name` and `photo` column has been added.
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

* Add a `Course` Model - `rails g model Course name:string start_date:date end_date:date teacher:references`
```ruby
def change
  create_table :courses do |t|
    t.string :name
    t.date :start_date
    t.date :end_date
    t.references :teacher, foreign_key: true

    t.timestamps
  end
end
```
* `rails db:migrate`
* **commit**

#### A `Student` model

* One more model - `rails g model Student name:string grade:integer age:integer course:references`
```ruby
def change
  create_table :students do |t|
    t.string :name
    t.integer :grade
    t.integer :age
    t.references :course, foreign_key: true

    t.timestamps
  end
end
```
* `rails db:migrate`

#### Create Many-to-Many relationship

```ruby
rails g migration CreateJoinTableTeachersStudents teachers students
```
* `rails db:migrate`
* **commit**

We did it!

Let's check out `db/schema.rb` to visualize our schema

## Adding relations

Now add your relationships in your models:

```ruby
class Teacher < ApplicationRecord
    has_many :courses
    has_and_belongs_to_many :students
end
```

```ruby
class Course < ApplicationRecord
    belongs_to :teacher
    has_many :students
end
```

```ruby
class Student < ApplicationRecord
    belongs_to :course
    has_and_belongs_to_many :teachers   
end
```

## Seeding the data

Create teachers, courses, and students in your `db/seeds.rb` file.  

> If you change seed file and want to run it again you should run `rails db:reset` instead as this will delete all the entries before seeding

[Use this](db/seeds.rb) file as your seed data.

Save this as your `db/seeds.rb`

Then run `rails db:seed`.

## Playing around with the relations

Let's jump back into the console (`rails c`) and make sure these relations are working as we expect!

Before jumping into the console, add `gem 'rb-readline', '~> 0.5.3'` to your Gemfile and `bundle install`.

Use the console (`rails c`) to make sure these relations are working as we expect!
Run: 

```ruby
Student.all
```

and

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

```ruby
<h2>Teachers</h2>

<ul>
  <% @teachers.each do |teacher| %>
    <li>
      <%= link_to teacher.name, teacher_path(teacher) %>
    </li>
  <% end %>
</ul>
```

Start your server: `rails s` and go to `http://localhost:3000/teachers`

Now let's add a `show` method

```ruby
def show
  @teacher = Teacher.find(params[:id])
end
```

And add a view to `app/views/teachers/show.html.erb`

```ruby
<%= @teacher.name %>
<% if @teacher.photo %>
  <div class="teacher-photo-area">
    <%= image_tag @teacher.photo %>
  </div>
<% end %>
```

Add a bit of styling to `app/assets/stylesheets/teachers.scss`

```css
.teacher-photo-area img {
    max-width: 200px;
}
```

#### Courses

Now let's update our routes.  We can nest courses under teachers.

```ruby
resources :teachers, only: [:index, :show] do
  resources :courses, only: [:index, :show]
end
```

Let's add our controller: `rails g controller courses`.

This time our controller is a little different because of the nesting.

Because of how nested routes work, we will get a `teacher_id` as a param for `courses`.

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

Let's add a link to the teacher's courses in `app/views/teachers/show.html.erb`

```ruby
....
<%= link_to "#{@teacher.name}'s courses", teacher_courses_path(@teacher) %>
```

For this link to work we need to setup the courses controller and view:

`app/controllers/courses_controller.rb`

```ruby
class CoursesController < ApplicationController
    def index
        @teacher = Teacher.find(params[:teacher_id])
        @courses = @teacher.courses
    end
end
```

`app/views/courses/index.html.erb`

```ruby
<h3><%=@teacher.name%>'s courses</h3>
<ul>
  <% @courses.each do |course| %>
    <li>
      <%= link_to course.name, teacher_course_path(@teacher, course) %>
    </li>
  <% end %>
</ul>
<%= link_to "Back to #{@teacher.name}", teacher_path(@teacher) %>
```

Awesome! We can now see the teacher's courses. What if we want to see a specific course?

Let's create our `show` method in the courses controller:

```ruby
def show
  @course = Course.find(params[:id])
  @students = @course.students.order(:name)
  @teacher = @course.teacher # or find by params[:teacher_id]
end
```

And add a `show` view.

```ruby
<h3><%= @course.name %></h3>

<div class="course-teacher">
  <b>Teacher:</b> <%= link_to @teacher.name, teacher_path(@teacher) %>
  |
  <%= link_to "Other Courses", teacher_courses_path(@teacher) %>
</div>

<table class='student-table'>
  <tr>
    <th>Name</th>
    <th>Age</th>
    <th>Grade</th>
  </tr>
  <% @students.each do |student| %>
    <tr>
      <td><%= student.name %></td>
      <td><%= student.age %></td>
      <td><%= student.grade %></td>
    </tr>
  <% end %>
</table>
```

Let's add a model method in our Course model to generate random pairs:

```ruby
  def generate_pairs
    students.shuffle.each_slice(2).to_a
  end
```

To use this method in the our Course view, we need to configure our Course controller and add:

```ruby
....
@pairs = @course.generate_pairs
....
```

Now the last piece, we can now generate pairs in our Course view:

```ruby
....
Random pairs:
<ul>
  <% @pairs.each do |pair| %>
    <li><%= pair.map(&:name).join(' & ') %></li>
  <% end %>
</ul>
```

## Advice

* Have exactly three tabs open in one terminal widow: bash, `rails s`, and `rails c`.
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
