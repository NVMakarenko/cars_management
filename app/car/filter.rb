# frozen_string_literal: true

class Filter
  def initialize(request, cars_db)
    @request = request
    @cars_list = cars_db
  end

  def call
    search_make
    search_model
    search_year
    search_price
  end

  private

  def search_make
    result = @cars_list.select { |car| car.make.downcase == @request.make }
    return @cars_list if result.empty?

    @cars_list = result
  end

  def search_model
    result = @cars_list.select { |car| car.model.downcase == @request.model }
    return @cars_list if result.empty?

    @cars_list = result
  end

  def search_year
    return show_year_from_zero(@request.year_to) if @request.year_from.to_i.zero?
    return show_year_to_now(@request.year_from, @request.year_to) unless @request.year_from.to_i.zero?
  end

  def search_price
    return show_price_from(@request.price_to) if @request.price_from.to_i.zero?
    return show_price_to_limit(@request.price_from, @request.price_to) unless @request.price_from.to_i.zero?
  end

  def show_year_from_zero(year_to)
    return @cars_list if year_to.to_i.zero?

    @cars_list.select { |car| car.year.to_i <= year_to.to_i }
  end

  def show_year_to_now(year_from, year_to)
    return @cars_list.select { |car| car.year.to_i >= year_from } if year_to.to_i.zero?

    @cars_list.select do |car|
      car.year.to_i >= year_from && car.year.to_i <= year_to
    end
  end

  def show_price_from(price_to)
    return @cars_list if price_to.to_i.zero?

    @cars_list.select { |car| car.price.to_i <= price_to }
  end

  def show_price_to_limit(price_from, price_to)
    return @cars_list.select { |car| car.price.to_i >= price_from } if price_to.to_i.zero?

    @cars_list.select do |car|
      car.price.to_i >= price_from && car.price.to_i <= price_to
    end
  end
end
