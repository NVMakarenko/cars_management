# frozen_string_literal: true

require_relative 'helpers/menu_constants'

class Menu
  include MenuConstants

  def call(current_user)
    @current_user = current_user
    print_menu
    decision = gets.chomp.to_i
    @current_user = ExecuteMenu.new(decision, @current_user).call
    return if decision == 4

    call(@current_user)
  end

  private

  def print_menu
    puts I18n.t('menu.search_car', menu_option: SEARCH_CAR).blue
    puts I18n.t('menu.show_list_cars', menu_option: SHOW_LIST_CARS).blue
    puts I18n.t('menu.help', menu_option: SHOW_HELP).blue
    puts I18n.t('menu.exit', menu_option: EXIT).blue
    print_additional_menu
  end

  def print_additional_menu
    if @current_user
      puts I18n.t('show_my_search', menu_option: LOGIN_OR_SEARCHES).blue
      puts I18n.t('log_out', menu_option: SIGN_OR_LOGOUT).blue
    else
      puts I18n.t('log_in', menu_option: LOGIN_OR_SEARCHES).blue
      puts I18n.t('sign_up', menu_option: SIGN_OR_LOGOUT).blue
    end
  end
end
