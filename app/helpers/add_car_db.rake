# frozen_string_literal: true

namespace :db do
  include MenuConstants

  desc 'add new car to db'
  task :add_car, :amount_of_cars do |_task, args|
    amount_of_cars = args[:amount_of_cars].to_i
    amount_of_cars = 1 if amount_of_cars.zero?
    db_data = Database.new(DB_CARS).load_file
    amount_of_cars.times { db_data.push(new_car) }
    Database.new(DB_CARS).save(db_data)
    puts "#{amount_of_cars} new car_s was added to DB Car"
  end
end

def new_car
  make = Faker::Vehicle.make
  { id: Faker::IDNumber.valid,
    make: make,
    model: Faker::Vehicle.model(make_of_model: make),
    year: Faker::Vehicle.year,
    odometer: Faker::Vehicle.kilometrage,
    price: Faker::Commerce.price(range: 2_000..100_000).to_i,
    description: Faker::Vehicle.fuel_type,
    date_added: Faker::Date.in_date_period.strftime('%d/%m/%y') }
end
