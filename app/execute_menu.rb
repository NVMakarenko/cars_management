# frozen_string_literal: true

class ExecuteMenu
  DB_CARS = 'db/db.yml'
  SEARCH_CAR = 1
  SHOW_LIST_CARS = 2
  SHOW_HELP = 3
  EXIT = 4
  LOGIN_OR_SEARCHES = 5
  SIGN_OR_LOGOUT = 6

  def initialize(decision, current_user)
    @decision = decision
    @current_user = current_user
  end

  def call
    case @decision
    when SEARCH_CAR, SHOW_LIST_CARS, SHOW_HELP, EXIT then exec_main_menu
    when LOGIN_OR_SEARCHES, SIGN_OR_LOGOUT then additional_action
    else
      puts I18n.t('decision.error')
    end
    @current_user
  end

  private

  def exec_main_menu
    case @decision
    when SEARCH_CAR then search_car
    when SHOW_LIST_CARS then show_list_cars
    when SHOW_HELP then show_help
    when EXIT then puts I18n.t('decision.exit')
    end
  end

  def additional_action
    case @decision
    when LOGIN_OR_SEARCHES then exec_login_or_searches
    when SIGN_OR_LOGOUT then exec_sign_or_logout
    end
  end

  def search_car
    puts I18n.t('decision.search')
    puts I18n.t('index.select_search_rules').light_magenta
    request = Request.new
    search_and_sort_cars(request)
  end

  def search_and_sort_cars(request)
    search_result = Filter.new(request, init_cars_list).call
    sort = Sort.new.call(search_result)
    Output.new(sort).call
    Statistic.new(current_user: @current_user, search_result: search_result, current_request: request).call
  end

  def show_list_cars
    puts I18n.t('decision.show_all')
    list_all_cars = init_cars_list
    sort = Sort.new.call(list_all_cars)
    Output.new(sort).call
  end

  def show_help
    puts
    puts I18n.t('decision.help').yellow
    puts I18n.t('help.first', menu_option: SEARCH_CAR).yellow
    puts I18n.t('help.second', menu_option: SHOW_LIST_CARS).yellow
    puts I18n.t('help.third', menu_option: SHOW_HELP).yellow
    puts I18n.t('help.fourth', menu_option: EXIT).yellow
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
    user_searches = Statistic.new(current_user: @current_user).show_user_search
    Output.new(user_searches).call
  end

  def log_out
    puts I18n.t('user.log_out', user_email: @current_user.email)
    @current_user = nil
  end

  def init_cars_list
    cars_list = Database.new(DB_CARS).load_file
    cars_list.map { |car| Car.new(car) }
  end
end
