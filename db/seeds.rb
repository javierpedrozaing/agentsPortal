# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Clear existing data
Agent.destroy_all

# Generate 10 agents
10.times do
  user = User.create!(
    name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: '12345678',
    role: 'agent',
    active: true
  )

  Agent.create!(
    city: Faker::Address.city,
    state: Faker::Address.state,
    address_home: Faker::Address.street_address,
    zip_code: Faker::Address.zip_code,
    licence: Faker::IDNumber.unique.valid,
    split: Faker::Number.decimal(l_digits: 2),
    phone: Faker::PhoneNumber.phone_number,
    user: user
  )
end

user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email
