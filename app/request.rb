# frozen_string_literal: true

class Request
  REQUEST_QUESTION_STYLE = :blue
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
    print I18n.t('request.make').colorize(REQUEST_QUESTION_STYLE)
    params[:make] = gets.chomp.downcase
    @make = params[:make] unless params[:make].empty?
    set_instance_model
  end

  def set_instance_model(params = {})
    print I18n.t('request.model').colorize(REQUEST_QUESTION_STYLE)
    params[:model] = gets.chomp.downcase
    @model = params[:model] unless params[:model].empty?
  end

  def set_instance_year(params = {})
    print I18n.t('request.year_from').colorize(REQUEST_QUESTION_STYLE)
    params[:year_from] = gets.chomp.to_i
    @year_from = params[:year_from] unless params[:year_from].zero?
    set_instance_year_to
  end

  def set_instance_year_to(params = {})
    print I18n.t('request.year_to').colorize(REQUEST_QUESTION_STYLE)
    params[:year_to] = gets.chomp.to_i
    @year_to = params[:year_to] unless params[:year_to].zero?
  end

  def set_instance_price_from(params = {})
    print I18n.t('request.price_from').colorize(REQUEST_QUESTION_STYLE)
    params[:price_from] = gets.chomp.to_i
    @price_from = params[:price_from] unless params[:price_from].zero?
  end

  def set_instance_price_to(params = {})
    print I18n.t('request.price_to').colorize(REQUEST_QUESTION_STYLE)
    params[:price_to] = gets.chomp.to_i
    @price_to = params[:price_to] unless params[:price_to].zero?
  end
end
