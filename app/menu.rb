# frozen_string_literal: true

require_relative 'filter'
require_relative 'module/output_cars_table'
require_relative 'module/sort'

class Menu
  include OutputCarsTable
  include Sort

  DB_CARS = 'db/db.yml'
  DB_REQUESTS = 'db/request_history.yml'
  MENU_OPTIONS = [1, 2, 3, 4].freeze

  def call
    loop do
      puts
      I18n.t('menu').each { |_key, value| puts value.blue }
      decision = gets.chomp.to_i
      puts I18n.t('decision.error') unless MENU_OPTIONS.include?(decision)
      menu_option(decision) if MENU_OPTIONS.include?(decision)
      break if decision == 4
    end
  end

  private

  def menu_option(decision)
    search_car if decision == 1
    show_list_cars if decision == 2
    show_help if decision == 3
    puts I18n.t('decision.exit') if decision == 4
  end

  def search_car
    puts I18n.t('decision.search')
    puts I18n.t('index.select_search_rules').light_magenta
    request = Request.new
    search_result = Filter.new(request, DB_CARS).call
    Statistic.new(search_result, request, DB_REQUESTS).call
  end

  def show_list_cars
    puts I18n.t('decision.show_all')
    list_all_cars = init_cars_list(DB_CARS)
    sort = sort(list_all_cars)
    output(sort)
  end

  def show_help
    puts
    puts I18n.t('decision.help')
    I18n.t('help').each { |_key, value| puts value }
  end
end
