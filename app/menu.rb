# frozen_string_literal: true

require_relative 'filter'
require_relative 'statistic'

class Menu
  DB_CARS = 'db/db.yml'
  DB_REQUESTS = 'db/request_history.yml'
  MENU_OPTIONS = [1, 2, 3, 4].freeze
  MENU_OPTIONS_STYLE = :blue
  SEARCH_CAR_STYLE = :light_magenta

  def call
    puts
    I18n.t('menu').each { |_key, menu_option| puts menu_option.colorize(MENU_OPTIONS_STYLE) }
    decision = gets.chomp.to_i
    puts I18n.t('decision.error') unless MENU_OPTIONS.include?(decision)
    execute_menu_option(decision) if MENU_OPTIONS.include?(decision)
    return if decision == 4

    call
  end

  private

  def execute_menu_option(decision)
    search_car if decision == 1
    show_list_cars if decision == 2
    show_help if decision == 3
    puts I18n.t('decision.exit') if decision == 4
  end

  def search_car
    puts I18n.t('decision.search')
    puts I18n.t('index.select_search_rules').colorize(SEARCH_CAR_STYLE)
    request = Request.new
    search_result = Filter.new(request, init_cars_list(DB_CARS)).call
    sort = Sort.new.call(search_result)
    OutputCarsTable.new(sort).call
    Statistic.new(search_result, request, DB_REQUESTS).call
  end

  def show_list_cars
    puts I18n.t('decision.show_all')
    list_all_cars = init_cars_list(DB_CARS)
    sort = Sort.new.call(list_all_cars)
    OutputCarsTable.new(sort).call
  end

  def show_help
    puts
    puts I18n.t('decision.help')
    I18n.t('help').each { |_key, help_option| puts help_option }
  end

  def init_cars_list(cars_db)
    cars_list = YAML.load_file(cars_db)
    cars_list.map { |car| Car.new(car) }
  end
end
