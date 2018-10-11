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
Category.destroy_all
Filter.destroy_all
Option.destroy_all

lviv = City.create(name: 'Lviv')
kiev = City.create(name: 'Kiev')

ghost = User.create(name: 'Ghost', password: 'My_name_is_Ghost', email: 'ghost@email.com', city: lviv, balance: 0)
john = User.create(name: 'John', password: 'My_name_is_John', email: 'john@email.com', city: lviv, balance: 1000)
maria = User.create(name: 'Maria', password: 'My_name_is_Maria', email: 'maria@email.com', city: kiev, balance: 500)
din = User.create(name: 'Din', password: 'My_name_is_Din', email: 'din@email.com', city: kiev, balance: 250)
don = User.create(name: 'Don', password: 'My_name_is_Don', email: 'don@email.com', city: lviv, balance: 1300)

size_40 = Option.create(option_value: '40')
size_42 = Option.create(option_value: '42')
size = Filter.create(filter_name: 'size', options: [ size_40, size_42 ])


red = Option.create(option_value: 'red')
blue = Option.create(option_value: 'blue')
color = Filter.create(filter_name: 'color', options: [ red, blue ])

skies = Category.create(name: 'ski', filters: [color, size])
ski = Item.create(owner: john, name: 'ski', daily_price_cents: 400, category: skies)
fast_ski = Item.create(owner: din, name: 'fast ski', daily_price_cents: 1000)
slow_ski = Item.create(owner: don, name: 'slow ski', daily_price_cents: 300, category: skies)
boot = Item.create(owner: don, name: 'boot', daily_price_cents: 300)

Booking.create(item: ski, renter: maria, start_date: Time.now, end_date: Time.now + 10.days, cost_cents: 400 * 10)
Booking.create(item: fast_ski, renter: don, start_date: Time.now, end_date: Time.now + 10.days, cost_cents: 1000 * 10)
Booking.create(item: slow_ski, renter: maria, start_date: Time.now - 5.days, end_date: Time.now - 1.day, cost_cents: 300 * 10)

Review.create(author: maria, reviewable: ski, description: 'Very nice ski')
Review.create(author: maria, reviewable: john, description: 'Nice ski seller')
Review.create(author: maria, reviewable: slow_ski, description: 'They are too slow')
