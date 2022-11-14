# frozen_string_literal: true

class RequestQuantity
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :total_quantity, :request_quantity

  def initialize(make = nil, model = nil, year_from = nil, year_to = nil, price_from = nil, price_to = nil, total_quantity = 0, request_quantity = 1)
    self.make = make
    self.model = model
    self.year_from = year_from
    self.year_to = year_to
    self.price_from = price_from
    self.price_to = price_to
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
