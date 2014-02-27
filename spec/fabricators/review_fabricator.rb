Fabricator(:review) do
  rating { Random.rand(6) }
  content { Faker::Lorem.paragraph(2) }
  video
  user
end
