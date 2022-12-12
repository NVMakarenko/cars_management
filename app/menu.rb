# frozen_string_literal: true

require_relative 'filter'
require_relative 'statistic'
require_relative 'user/user_request'

class Menu
  DB_CARS = 'db/db.yml'

  def call(current_user)
    @current_user = current_user
    print_menu
    decision = gets.chomp.to_i
    execute_menu_option(decision)
    return if decision == 4

    call(@current_user)
  end

  private

  def print_menu
    puts
    I18n.t('menu').each_value { |menu_option| puts menu_option.blue }
    print_additional_menu
  end

  def print_additional_menu
    if @current_user
      puts I18n.t('show_my_search').blue
      puts I18n.t('log_out').blue
    else
      puts I18n.t('log_in').blue
      puts I18n.t('sign_up').blue
    end
  end

  def execute_menu_option(decision)
    case decision
    when 1..4 then exec_main_menu(decision)
    when 5..6 then additional_action(decision)
    else
      puts I18n.t('decision.error')
    end
  end

  def exec_main_menu(decision)
    case decision
    when 1 then search_car
    when 2 then show_list_cars
    when 3 then show_help
    when 4 then puts I18n.t('decision.exit')
    end
  end

  def additional_action(decision)
    case decision
    when 5 then exec_login_or_searches
    when 6 then exec_sign_or_logout
    end
  end

  def search_car
    puts I18n.t('decision.search')
    puts I18n.t('index.select_search_rules').light_magenta
    request = Request.new
    search_and_sort_cars(request)
  end

  def search_and_sort_cars(request)
    search_result = Filter.new(request, init_cars_list(DB_CARS)).call
    sort = Sort.new.call(search_result)
    Output.new(sort).call
    Statistic.new(@current_user, search_result, request).call
  end

  def show_list_cars
    puts I18n.t('decision.show_all')
    list_all_cars = init_cars_list(DB_CARS)
    sort = Sort.new.call(list_all_cars)
    Output.new(sort).call
  end

  def show_help
    puts
    puts I18n.t('decision.help')
    I18n.t('help').each_value { |help_option| puts help_option }
  end

  def exec_login_or_searches
    if @current_user.nil?
      @current_user = Authentication.new.login
    else
      show_user_search
    end
  end

  def exec_sign_or_logout
    if @current_user.nil?
      @current_user = Authentication.new.sign_up
    else
      log_out
    end
  end

  def show_user_search
    user_searches = Statistic.new(@current_user, nil, nil).show_user_search
    Output.new(user_searches).call
  end

  def log_out
    puts I18n.t('user.log_out', user_email: @current_user.email)
    @current_user = nil
  end

  def init_cars_list(cars_db)
    cars_list = YAML.load_file(cars_db)
    cars_list.map { |car| Car.new(car) }
  end
end
