# frozen_string_literal: true

require 'yaml'
require 'date'
require_relative 'car'
require_relative 'request_quantity'

module SearchRule
  def init_cars_list
    cars_list = YAML.load_file('db/db.yml')
    cars_list.map do |car|
      Car.new(car[:id], car[:make], car[:model], car[:year], car[:odometer], car[:price],
              car[:description], car[:date_added])
    end
  end

  def search_make(list)
    print 'Please choose make: '
    make = gets.chomp.downcase
    @current_request = RequestQuantity.new(make) if make !=''
    @current_request = RequestQuantity.new unless make !=''
    result = list.select { |car| car.make.downcase == make }
    return list if result.empty?

    result
  end

  def search_model(list)
    print 'Please choose model: '
    model = gets.chomp.downcase
    @current_request.model = model if model !=''
    result = list.select { |car| car.model.downcase == model }
    return list if result.empty?

    result
  end

  def search_year(list)
    print 'Please choose year_from: '
    year_from = gets.chomp.to_i
    @current_request.year_from = year_from if year_from != 0
    print 'Please choose year_to: '
    year_to = gets.chomp.to_i
    @current_request.year_to = year_to if year_to != 0
    return show_year_from_zero(list, year_to) if year_from.zero?
    return show_year_to_now(list, year_from.to_i, year_to) unless year_from.zero?
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
    price_from = gets.chomp.to_i
    @current_request.price_from = price_from if price_from != 0
    print 'Please choose price_to: '
    price_to = gets.chomp.to_i
    @current_request.price_to = price_to if price_to !=0
    return show_price_from(list, price_to) if price_from.zero?
    return show_price_to_limit(list, price_from, price_to) unless price_from.zero?
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

  def statistic(result)
    puts '----------------------------------'
    puts 'Statistic'
    @current_request.total_quantity = result.size
    puts "Total Quantity: #{@current_request.total_quantity}"
    request_list = YAML.safe_load(File.open('db/request.yml'), permitted_classes: [RequestQuantity])
    catch_uniq_request(request_list)
    File.open('db/request.yml', 'rb+') { |file| file.write(request_list.to_yaml) }
  end

  def catch_uniq_request(request_list)
    catch :request_uniq do
      request_list.each do |request|
        if request == (@current_request)
          (request.request_quantity += 1) &&
            (puts "Request Quantity: #{request.request_quantity}")
        end
        throw :request_uniq if request == (@current_request)
      end
      request_list.push(@current_request)
      puts "Request Quantity: #{@current_request.request_quantity}"
    end
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
    statistic(result)
  end
end
