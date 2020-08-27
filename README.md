# ![](https://ga-dash.s3.amazonaws.com/production/assets/logo-9f88ae6c9c3871690e33280fcf557f33.png)  WEB DEVELOPMENT IMMERSIVE

## Getting started

1. Fork and clone
2. `cd` into project directory
3. follow these [Setup instructions](/setup.md#set-up)

# Active Record

### Objectives
*After this lesson, students will be able to:*
- LEARN ACTIVE RECORD


## What _is_ Active Record???

Active Record is the M in [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller) - the model - which is the layer of the system responsible for representing business data and logic. Active Record facilitates the creation and use of business objects whose data requires persistent storage to a database. It is an implementation of the Active Record pattern which itself is a description of an Object Relational Mapping system.

Active Record is what we're going to use to manage our database for our Rails app. It comes built in to Rails, but you can also use it with Sinatra.

Active Record is what's called an [ORM](https://en.wikipedia.org/wiki/Object-relational_mapping), or <b>O</b>bject <b>R</b>elational <b>M</b>apping (tool). Object Relational Mapping is a technique that connects the rich objects of an application to tables in a relational database management system. Using ORM, the properties and relationships of the objects in an application can be easily stored and retrieved from a database without writing SQL statements directly and with less overall database access code.

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

> So where would be be using these AR (Active Record) methods?

We are able to use these active record methods in several places across our Rails app. Inside of our `db/seed.rb`, we will want to use the `.create` methods in order to populate our database. 

## AR Models

Instead of just getting a hash of information, an AR instance is an object with a lot of helpful methods on it. The `class`es for our AR models are defined inside of our `/app/models/` directory. When we run `rails g model` we are actually creating a new model class for one of our tables. It will import from the global `ActiveRecord` class which is what gives us all of these default methods.

The coolest of all: we get an `attr_accessor` for every column.

```ruby
stacey = Student.find(7)
stacey.name # => 'Stacey'
stacey.grade # => 90
stacey.grade = 100
stacey.grade # => 100
stacey.name = 'Dr. Stacey'
```

Now this so far is only updating our non-persistent variable of this student. If we want to update the student in our table it's easy as the [`.save`](https://apidock.com/rails/ActiveRecord/Base/save) method
```ruby
stacey.save
```
No SQL needed.

Or we can use the [`update`](http://guides.rubyonrails.org/active_record_basics.html#update) method instead of the accessors
```ruby
stacey.update(name: 'Dr. Stacey', grade: 100)
```

> Where do we use these ActiveRecord methods?

There are several places across our Rails app where we can apply these methods. We can, of course, access these methods inside of our `/app/models/` files where the model classes are defined. We can even extend the functionality of these classes if we wanted to.

We typically will use the create methods inside of our `/db/seeds.rb` file as well to populate our database.

Lastly, we will also need to use these methods inside of our controllers. This is where most of our logic will take place and we will need full CRUD functionality here.

### We Do:

Rails has a handy CLI tool built in for testing AR models, `rails console` or `rails c` for short. This will drop us into a Ruby REPL in our terminal and load in all of our Rails code, including our models which will give us access to our DB.

Let's use this to find a teacher from our database and update their row in the table.

 - Find the third teacher in the DB.
 - Change their name property and then save it to the database (two commands)
 - update the teacher's photo in the DB in one line. (here is a sample photo: `https://i.imgflip.com/15a5s4.jpg`)

## Active Record Relations

Assume we have a few tables, `students`, `teachers`, and `courses`.  And assume that a teacher can teach many courses but a student can only belong to one course.

Thus, the `students` table would have a `course_id`.  And the `course` table would have a `teacher_id`.

As long as we have that, we can represent all of our relations using AR!

```ruby
class Teacher < ApplicationRecord
    has_many :courses
    has_many :students, through: :courses
end

class Course < ApplicationRecord
    belongs_to :teacher
    has_many :students
end

class Student < ApplicationRecord
    belongs_to :course
    has_one :teacher, through: :course
end
```

Now look how much we can do without having to write any SQL!

```ruby
ari = Teacher.find_by(name: 'Professor Ari')
ari.courses # => a bunch of courses! (Instances of Course)
ari.students # => a bunch of students! (Instances of Student)

stacey = Student.find(some_student_id)
stacey.course # => the Course instance
stacey.teacher # => the Teacher instance (maybe our updated teacher)

course = ari.courses.first
course.students # => a bunch of students
course.teacher # => ari
```

Remember that we are using an ORM but this is _still Ruby_. `Student`, `Teacher`, and `Courses` are all classes.  This means we can add our own methods

```ruby
class Student < ApplicationRecord
  # ...

  # this allows us to take any collection of students
  # and call `top` on it to get the student with the best grade

  def self.top
    order(grade: :desc).first
  end

  # or even better:
  # scope :top, -> { order(grade: :desc).first }

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

> scoping in rails is similar to adding custom methods to our class. It is sometimes referred to as "syntactic sugar". You can learn more about scoping here: [scope](https://api.rubyonrails.org/classes/ActiveRecord/Scoping/Named/ClassMethods.html#method-i-scope) 

### We do:

Let's test out our new methods inside of our `rails console`.

- find all of the teachers
- print each teachers name and the courses that they teach
- find the first teachers top student
- update the grades for all the students of the second teachers to `100` in one command
- get the grades for the course that the last student is in.
- get the pairs for the first course of the fifth teacher

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
