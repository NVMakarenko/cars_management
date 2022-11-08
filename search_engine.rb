# frozen_string_literal: true

module SearchRule
  require 'yaml'
  require 'date'
  require_relative 'car'

  def init_cars_list
    list_of_objects = []
    cars_list = YAML.load_file('db/db.yml')
    cars_list.each do |car|
      list_of_objects.push(Car.new(car[:id], car[:make], car[:model], car[:year], car[:odometer], car[:price],
                                   car[:description], car[:date_added]))
    end
    list_of_objects
  end

  def search_make(list)
    print 'Please choose make: '
    make = gets.chomp.downcase
    result = list.select { |car| car.make.downcase == make }
    return list if result == []

    result
  end

  def search_model(list)
    print 'Please choose model: '
    model = gets.chomp.downcase
    result = list.select { |car| car.model.downcase == model }
    return list if result == []

    result
  end

  def search_year(list)
    print 'Please choose year_from: '
    year_from = gets.chomp.downcase.to_i
    print 'Please choose year_to: '
    year_to = gets.chomp.downcase.to_i
    result = show_year_from_zero(list, year_to) if year_from.zero?
    result = show_year_to_now(list, year_from, year_to) unless year_from.zero?
    result
  end

  def show_year_from_zero(list, year_to)
    return list if year_to.zero?

    list.select { |car| car.year.to_i <= year_to }
  end

  def show_year_to_now(list, year_from, year_to)
    return list.select { |car| car.year.to_i >= year_from } if year_to.zero?

    list.select do |car|
      car.year.to_i >= year_from && car.year.to_i <= year_to
    end
  end

  def search_price(list)
    print 'Please choose price_from: '
    price_from = gets.chomp.downcase.to_i
    print 'Please choose price_to: '
    price_to = gets.chomp.downcase.to_i
    result = show_price_from(list, price_to) if price_from.zero?
    result = show_price_to_limit(list, price_from, price_to) unless price_from.zero?
    result
  end

  def show_price_from(list, price_to)
    return list if price_to.zero?

    list.select { |car| car.price.to_i <= price_to }
  end

  def show_price_to_limit(list, price_from, price_to)
    return list.select { |car| car.price.to_i >= price_from } if price_to.zero?

    list.select do |car|
      car.price.to_i >= price_from && car.price.to_i <= price_to
    end
  end

  def filter(list)
    search_price(search_year(search_model(search_make(list))))
  end

  def sort(list)
    print 'Please choose sort option (date_added|price): '
    sort_option = gets.chomp.downcase
    print 'Please choose sort direction(desc|asc): '
    direction = gets.chomp.downcase
    return sort_price(list, direction) if sort_option == 'price'
    return list.sort_by!(&:date_added).reverse unless direction == 'asc'

    list.sort_by!(&:date_added)
  end

  def sort_price(list, direction)
    return list.sort_by!(&:price) if direction == 'asc'

    list.sort_by!(&:price).reverse
  end

  def output(result)
    puts '----------------------------------'
    puts 'Result: (if there are no proper car, we will advice you something else)'
    result.each do |car|
      car.to_hash.each do |key, value|
        puts "#{key.capitalize}: #{value}" unless key == 'date_added'
        puts "#{key.capitalize}: #{value.strftime('%d/%m/%Y')}" if key == 'date_added'
      end
      puts
    end
  end
end
