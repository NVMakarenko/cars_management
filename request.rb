# frozen_string_literal: true

class Request
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :total_quantity, :request_quantity

  def initialize(total_quantity = 0, request_quantity = 1)
    set_start_request_var
    @total_quantity = total_quantity
    @request_quantity = request_quantity
  end

  def ==(other)
    make == other.make &&
      model == other.model &&
      year_from == other.year_from &&
      year_to == other.year_to &&
      price_from == other.price_from &&
      price_to == other.price_to
  end

  private

  def set_start_request_var
    set_instance_char
    set_instance_year
    set_instance_price_from
    set_instance_price_to
    @make || @make = nil
    @model || @model = nil
    @year_from || @year_from = nil
    @year_to || @year_to = nil
    @price_from || @price_from = nil
    @price_to || @price_to = nil
  end

  def set_instance_char(params = {})
    print 'Please choose make: '
    params[:make] = gets.chomp.downcase
    print 'Please choose model: '
    params[:model] = gets.chomp.downcase
    @make = params[:make] unless params[:make].empty?
    @model = params[:model] unless params[:model].empty?
  end

  def set_instance_year(params = {})
    print 'Please choose year_from: '
    params[:year_from] = gets.chomp.to_i
    print 'Please choose year_to: '
    params[:year_to] = gets.chomp.to_i
    @year_from = params[:year_from] unless params[:year_from].zero?
    @year_to = params[:year_to] unless params[:year_to].zero?
  end

  def set_instance_price_from(params = {})
    print 'Please choose price_from: '
    params[:price_from] = gets.chomp.to_i
    @price_from = params[:price_from] unless params[:price_from].zero?
  end

  def set_instance_price_to(params = {})
    print 'Please choose price_to: '
    params[:price_to] = gets.chomp.to_i
    @price_to = params[:price_to] unless params[:price_to].zero?
  end
end
