# frozen_string_literal: true

require 'date'

class Car
  attr_accessor :id, :make, :model, :year, :odometer, :price, :description, :date_added

  def initialize(id, make, model, year, odometer, price, description, date_added)
    self.id = id
    self.make = make
    self.model = model
    self.year = year
    self.odometer = odometer
    self.price = price
    self.description = description
    self.date_added = Date.strptime(date_added, '%d/%m/%y')
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
