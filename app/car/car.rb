# frozen_string_literal: true

class Car
  attr_reader :id, :make, :model, :year, :odometer, :price, :description, :date_added

  def initialize(params = {})
    @id = params[:id]
    @make = params[:make]
    @model = params[:model]
    @year = params[:year]
    @odometer = params[:odometer]
    @price = params[:price]
    @description = params[:description]
    @date_added = Date.strptime(params[:date_added], '%d/%m/%y')
  end

  def to_hash
    hash = {}
    instance_variables.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
    hash
  end
end
