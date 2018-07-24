# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Item.destroy_all
Booking.destroy_all
Review.destroy_all

mountain = City.create(name: 'mountain')
beach = City.create(name: 'beach')

john = User.create(name: 'John', password: 'My_name_is_John', email: 'john@email.com', city: mountain)
maria = User.create(name: 'Maria', password: 'My_name_is_Maria', email: 'maria@email.com', city: beach)
din = User.create(name: 'Din', password: 'My_name_is_Din', email: 'din@email.com', city: beach)
don = User.create(name: 'Don', password: 'My_name_is_Don', email: 'don@email.com', city: mountain)

ski = Item.create(owner: john, name: 'ski', daily_price_cents: 400)
fast_ski = Item.create(owner: din, name: 'fast ski', daily_price_cents: 1000)
slow_ski = Item.create(owner: don, name: 'slow ski', daily_price_cents: 300)

Booking.create(item: ski, renter: maria, start_date: Time.now, end_date: Time.now + 10.days, cost_cents: 400 * 10)
Booking.create(item: fast_ski, renter: don, start_date: Time.now, end_date: Time.now + 10.days, cost_cents: 1000 * 10)
Booking.create(item: slow_ski, renter: maria, start_date: Time.now - 5.days, end_date: Time.now - 1.day, cost_cents: 300 * 10)

Review.create(author: maria, reviewable: ski, description: 'Very nice ski')
Review.create(author: maria, reviewable: john, description: 'Nice ski seller')
Review.create(author: maria, reviewable: slow_ski, description: 'They are too slow')