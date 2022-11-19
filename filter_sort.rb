# frozen_string_literal: true

require 'yaml'
require 'date'
require_relative 'car'
require_relative 'request'
require_relative 'statistic'

class FilterSort
  def initialize(request, cars_db)
    @request = request
    @cars_list = init_cars_list(cars_db)
  end

  def call
    search_result = filter(@cars_list)
    sorted_result = sort(search_result)
    output(sorted_result)
  end

  private

  def init_cars_list(cars_db)
    cars_list = YAML.load_file(cars_db)
    cars_list.map do |car|
      Car.new(car[:id], car[:make], car[:model], car[:year], car[:odometer], car[:price],
              car[:description], car[:date_added])
    end
  end

  def search_make(list)
    result = list.select { |car| car.make.downcase == @request.make }
    return list if result.empty?

    result
  end

  def search_model(list)
    result = list.select { |car| car.model.downcase == @request.model }
    return list if result.empty?

    result
  end

  def search_year(list)
    return show_year_from_zero(list, @request.year_to) if @request.year_from.to_i.zero?
    return show_year_to_now(list, @request.year_from, @request.year_to) unless @request.year_from.to_i.zero?
  end

  def search_price(list)
    return show_price_from(list, @request.price_to) if @request.price_from.to_i.zero?
    return show_price_to_limit(list, @request.price_from, @request.price_to) unless @request.price_from.to_i.zero?
  end

  def show_year_from_zero(list, year_to)
    return list if year_to.to_i.zero?

    list.select { |car| car.year.to_i <= year_to.to_i }
  end

  def show_year_to_now(list, year_from, year_to)
    return list.select { |car| car.year.to_i >= year_from } if year_to.zero?

    list.select do |car|
      car.year.to_i >= year_from && car.year.to_i <= year_to
    end
  end

  def show_price_from(list, price_to)
    return list if price_to.to_i.zero?

    list.select { |car| car.price.to_i <= price_to }
  end

  def show_price_to_limit(list, price_from, price_to)
    return list.select { |car| car.price.to_i >= price_from } if price_to.to_i.zero?

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
