User.create!(name:  "Example User",
  email: "example@framgia.com",
  password: "foobar",
  password_confirmation: "foobar",
  is_admin: true)

8.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@framgia.com"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    is_admin: false)
end
