# frozen_string_literal: true

require_relative 'filter'
require_relative 'statistic'

class Menu
  DB_CARS = 'db/db.yml'
  DB_REQUESTS = 'db/request_history.yml'

  def call
    puts
    I18n.t('menu').each_value { |menu_option| puts menu_option.blue }
    decision = gets.chomp.to_i
    execute_menu_option(decision)
    return if decision == 4

    call
  end

  private

  def execute_menu_option(decision)
    case decision
    when 1 then search_car
    when 2 then show_list_cars
    when 3 then show_help
    when 4
      puts I18n.t('decision.exit')
    else
      puts I18n.t('decision.error')
    end
  end

  def search_car
    puts I18n.t('decision.search')
    puts I18n.t('index.select_search_rules').light_magenta
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
