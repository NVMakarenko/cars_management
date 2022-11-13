# frozen_string_literal: true

class RequestQuantity
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :total_quantity, :request_quantity

  def initialize(make = '', model = '', year_from = 0, year_to = 0, price_from = 0, price_to = 0, total_quantity = 0, request_quantity = 1)
    @make = make
    @model = model
    @year_from = year_from
    @year_to = year_to
    @price_from = price_from
    @price_to = price_to
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
end
