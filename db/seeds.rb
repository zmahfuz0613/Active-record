# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
ari = Teacher.create!(name: 'Professor Ari', photo: 'http://aribrenner.com/media/images/ari0.jpg')
bell = Teacher.create!(name: 'Bell', photo: 'http://uploads.tapatalk-cdn.com/20161123/679e78cd8a276f76f1f962ba2a4c454e.jpg')
dom = Teacher.create!(name: 'Dom', photo: 'http://i.imgur.com/JRkmvOv.png')
drew = Teacher.create(name: 'Drew', photo: 'https://lh5.googleusercontent.com/-Po8zRYag1ns/TgvVNrnnRGI/AAAAAAAAFuQ/UBoR0jidi1s/w506-h750/241140_10150199352146566_646356565_7341938_4425157_o.jpg')
j = Teacher.create!(name: 'J', photo: 'https://avatars0.githubusercontent.com/u/12768542?v=4&s=400')
ramsey = Teacher.create!(name: 'Ramsey', photo: 'https://docs.npmjs.com/images/npm.svg')

puts "#{Teacher.count} teachers created!"


# ari courses
Course.create!(name: 'Stealing Snacks 101', teacher: ari, start_date: 1.month.ago, end_date: 2.days.from_now)
Course.create!(name: 'Dancing 201', teacher: ari, start_date: 3.weeks.ago, end_date: 2.weeks.from_now)
Course.create!(name: 'Being cute but not in an obvious way 301', teacher: ari, start_date: 1.day.ago, end_date: 2.days.from_now)

# bell courses
Course.create!(name: 'Legobuidling 101', teacher: bell, start_date: 3.days.ago, end_date: 4.weeks.from_now)
Course.create!(name: 'Bell 101: Becoming John Bell', teacher: bell, start_date: 2.weeks.ago, end_date: 2.months.from_now)
Course.create!(name: 'Bell 102: Un-becoming John Bell', teacher: bell, start_date: 2.weeks.ago, end_date: 2.months.from_now)
Course.create!(name: 'Bell 103: Re-becoming John Bell', teacher: bell, start_date: 2.weeks.ago, end_date: 2.months.from_now)
Course.create!(name: 'Ice Skating', teacher: bell, start_date: 2.weeks.ago, end_date: 2.months.from_now)

# dom courses
Course.create!(name: 'DOM101: Intro to The Dominic Object Model', teacher: dom, start_date: 2.days.ago, end_date: 2.days.from_now)
Course.create!(name: 'DOM102: The Dominic Object Model in You', teacher: dom, start_date: 4.days.ago, end_date: 3.weeks.from_now)
Course.create!(name: 'DOM103: Being more than just an Object', teacher: dom, start_date: 5.days.ago, end_date: 6.days.from_now)

# drew courses
101.upto(105) do |i|
  Course.create!(name: "Kotlin #{i}", teacher: drew, start_date: 1.day.ago, end_date: i.years.from_now)
  Course.create!(name: "Java #{i}", teacher: drew, start_date: 1.day.ago, end_date: i.years.from_now)
end

# j courses
Course.create!(name: 'Express 101: Express yourself with Express!', teacher: j, start_date: 3.days.ago, end_date: 4.weeks.from_now)
Course.create!(name: 'Express 102: Dreaming in Express', teacher: j, start_date: 7.days.ago, end_date: 5.weeks.from_now)
Course.create!(name: 'Flexbox 101: Trapped in Flexbox', teacher: j, start_date: 7.days.ago, end_date: 5.weeks.from_now)
Course.create!(name: 'Cats 101: Trapped in Catbox', teacher: j, start_date: 7.days.ago, end_date: 5.weeks.from_now)

# ramsey courses
Course.create!(name: 'Heroku 101: Are ~you~ hosted on Heroku?', teacher: ramsey, start_date: 1.week.ago, end_date: 3.days.from_now)
Course.create!(name: 'What programming langauge are ~you~', teacher: ramsey, start_date: 1.week.ago, end_date: 3.days.from_now)
Course.create!(name: 'NPM 101: How to deploy yourself to NPM', teacher: ramsey, start_date: 1.week.ago, end_date: 3.days.from_now)


puts "#{Course.count} courses created!"


Course.all.find_each do |course|
  5.times do
    Student.create!(name: Faker::Name.name, course: course, grade: 50 + rand(50), age: 15 + rand(40))
  end
end

puts "#{Student.count} students created!"