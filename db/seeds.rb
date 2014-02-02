# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

movies = ["Southpark", "Futurama", "Monk", "Fear and Loathing in Las Vegas", "The Hunt", "De zwarte boek", "Attenberg", "From Dusk till Dawn", "The Experiment"]

5.times { Category.create(name: Faker::Commerce.department)}

50.times do
  movie = movies.sample
  Video.create(title: movie, description: Faker::Lorem.paragraph(Random.rand(1..3)), small_cover_url: "http://placehold.it/166x236.jpg&text=#{movie}", large_cover_url: "http://placehold.it/655x375.jpg&text=#{movie}", category: Category.find(Random.rand(1..5))) 
end

15.times { User.create(email: Faker::Internet.email, full_name: Faker::Name.name, password: "secret") }
100.times { Review.create(content: Faker::Lorem.paragraph(Random.rand(1..4)), user: User.find(Random.rand(1..User.count)), video: Video.find(Random.rand(1..Video.count)), rating: Random.rand(1..5) ) }