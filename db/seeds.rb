# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(email: 'bill@foo.bar', password: '123456')
Question.create!([{ title: 'Example question 1 title', body: 'Example question 1 body', author: user },
                  { title: 'Example question 2 title', body: 'Example question 2 body' }])
