# frozen_string_literal: true

class Car
  attr_accessor :id, :make, :model, :year, :odometer, :price, :description, :date_added

  def initialize(id, make, model, year, odometer, price, description, date_added)
    @id = id
    @make = make
    @model = model
    @year = year
    @odometer = odometer
    @price = price
    @description = description
    @date_added = date_added
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
