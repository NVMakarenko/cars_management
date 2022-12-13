# frozen_string_literal: true

class Menu
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
end
