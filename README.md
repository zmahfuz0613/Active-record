# ![](https://ga-dash.s3.amazonaws.com/production/assets/logo-9f88ae6c9c3871690e33280fcf557f33.png)  WEB DEVELOPMENT IMMERSIVE

## Getting started

1. Fork
1. Create a feature branch
1. Clone
1. Pull Request

# Active Record

### Objectives
*After this lesson, students will be able to:*
- LEARN ACTIVE RECORD

[Setup instructions here](/setup.md#set-up)

## What _is_ Active Record???

Active Record is what we're going to use to manage our database for our Rails app. It comes built in to Rails, but you can also use it with Sinatra.

Active Record is what's called an ORM, or <b>O</b>bject <b>R</b>elational <b>M</b>apping (tool). It allows us to represent all of the information in our database as objects.

Here's a sneak peak of what that looks like.


### Reading

Getting many:
```sql
SELECT * FROM students;
```
```rb
Student.all
```

Getting one:
```sql
SELECT * FROM students
WHERE id = 7;
```
```rb
Student.find(7)
```

Nice!

```sql
SELECT name FROM students;
```
```ruby
Student.pluck(:name)
```

Cool!


```sql
SELECT * FROM students
WHERE (students.age BETWEEN 20 AND 30);
```
```ruby
Student.where(age: 20..30)
```

Awesome!

### Updating

Updating many:
```sql
UPDATE students
SET grade = 100
WHERE (students.age BETWEEN 20 AND 30);
```
```ruby
Student.where(age: 20..30).update_all(grade: 100)
```

Updating one:
```sql
UPDATE students
SET name = 'Stacey'
WHERE id = 7;
```
```ruby
Student.find(7).update(name: 'Stacey')
```

Fun!


### Inserting


```sql
INSERT INTO teachers
(name, photo)
VALUES ('Dr Teach', 'me.jpg');
```
```ruby
Teacher.create(name: 'Dr Teach', photo: 'me.jpg')
```

Sick!

## AR Models

Instead of just getting a hash of information, an AR instance is an object with a lot of helpful methods on it.

The coolest of all: we get an `attr_accessor` for every column.

```ruby
stacey = Student.find(7)
stacey.name # => 'Stacey'
stacey.grade # => 90
stacey.grade = 100
stacey.grade # => 100
stacey.name = 'Dr. Stacey'
```

Now if we want to update the student in our table it's easy as the [`save`](https://apidock.com/rails/ActiveRecord/Base/save) method
```ruby
stacey.save
```
No SQL needed.

Or we can use the [`update`](http://guides.rubyonrails.org/active_record_basics.html#update) method instead of the accessors
```ruby
stacey.update(name: 'Dr. Stacey', grade: 100)
```


## Active Record Relations

Assume we have a few tables, `students`, `teachers`, and `courses`.  And assume that a teacher can teach many courses but a student can only belong to one course.

Thus, the `students` table would have a `course_id`.  And the `course` table would have a `teacher_id`.

As long as we have that, we can represent all of our relations using AR!

```ruby
class Teacher < ApplicationRecord
    has_many :courses
    has_and_belongs_to_many :students
end

class Course < ApplicationRecord
    belongs_to :teacher
    has_many :students
end

class Student < ApplicationRecord
    belongs_to :course
    has_and_belongs_to_many :teacher   
end
```

Now look how much we can do without having to write any SQL!

```ruby
ari = Teacher.find_by(name: 'Professor Ari')
ari.courses # => a bunch of courses! (Instances of Course)
ari.students # => a bunch of students! (Instances of Student)

stacey = Student.find(some_student_id)
stacey.course # => the Course instance
stacey.teacher # => the Teacher instance (maybe ari)

course = ari.courses.first
course.students # => a bunch of students
course.teacher # => ari
```

Remember that we are using an ORM but this is _still Ruby_. `Student`, `Teacher`, and `Courses` are all classes.  This means we can add our own methods

```ruby
class Course < ApplicationRecord
  # ...
  def grades
    students.pluck(:grade)
  end

  def top_student
    students.top # top scope defined in students
  end

  # finally! a random pair generator written in ruby!
  def generate_pairs
    students.shuffle.each_slice(2).to_a
  end
end
```

```ruby
class Teacher < ApplicationRecord
  # ...
  def top_student
    students.top # top scope defined in students
  end

  def say_hi
    "Hi, I am #{name} and I teach #{courses.count} courses"
  end
end
```

```ruby
class Student < ApplicationRecord
  # ...

  # this allows us to take any collection of students
  # and call `top` on it to get the student with the best grade
  scope :top, -> { order(grade: :desc).first }

  def peers
    Student.where(course_id: course_id)
  end

  # or even better:
  # def peers
  #   course.students
  # end

  # or even even better
  # has_many :peers, through: :course, source: :students

  def say_hi
    "Hi, I am #{name} and I am #{age} years old"
  end
end
```

> Our `top_student` method is defined the same on two classes. If only there were a way to share this [concern](http://api.rubyonrails.org/v5.1/classes/ActiveSupport/Concern.html)...

### Commands to know

* `rails s` (`rails server`)
* `rails c` (`rails console`)
* `rails g model Thing`
  - Gives you a blank model, a migration for the table, tests, etc
* `rails g controller Things`
  - Give you a blank controller, a views directory, maybe some other stuff
* `rails g migration DoSomethingToSomeTable`
* `rails db:SOME_COMMAND`: `:create`, `:migrate`, `:seed`, `:drop`, `:setup`...
* `rails dbconsole`
  - On the off-chance you actually want a dbconsole to execute SQL
  - Do not use this *ever* in production


## Dirty work

We are now going to build this app from scratch.

`cd` into whatever directory you normally put new projects and we will follow [instructions.md](instructions.md#building-a-rails-app) together.

## Resources

* [Active Record Query Interface](http://guides.rubyonrails.org/active_record_querying.html)
* AR Class methods
  * [`where` clauses](https://apidock.com/rails/ActiveRecord/QueryMethods/where)
  * [`find_by` clauses](https://apidock.com/rails/v4.0.2/ActiveRecord/FinderMethods/find_by)
  * `find`, `update_all`, `delete_all`, `destroy_all`, etc.
* AR Instance methods
  * `save`, `update`, `delete`, `destroy`, etc.
* [Rails Command Line](http://guides.rubyonrails.org/command_line.html)
* [`rails db:` commands](http://jacopretorius.net/2014/02/all-rails-db-rake-tasks-and-what-they-do.html)

## Conclusion
- When is AR easier than writing raw SQL?
- How can we learn more about AR?
