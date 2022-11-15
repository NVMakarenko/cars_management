# frozen_string_literal: true

class Request
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :total_quantity, :request_quantity

  def initialize(make = nil, model = nil, year_from = nil, year_to = nil, price_from = nil, price_to = nil, total_quantity = 0, request_quantity = 1)
    print 'Please choose make: '
    make = gets.chomp.downcase
    print 'Please choose model: '
    model = gets.chomp.downcase
    print 'Please choose year_from: '
    year_from = gets.chomp.to_i
    print 'Please choose year_to: '
    year_to = gets.chomp.to_i
    print 'Please choose price_from: '
    price_from = gets.chomp.to_i
    print 'Please choose price_to: '
    price_to = gets.chomp.to_i
    self.make = make if make != ''
    self.model = model if model != ''
    self.year_from = year_from if year_from !=0
    self.year_to = year_to if year_to !=0
    self.price_from = price_from if price_from != 0
    self.price_to = price_to if price_to != 0
    self.total_quantity = total_quantity
    self.request_quantity = request_quantity
  end

  def ==(other)
    make == other.make &&
      model == other.model &&
      year_from == other.year_from &&
      year_to == other.year_to &&
      price_from == other.price_from &&
      price_to == other.price_to
  end
end
