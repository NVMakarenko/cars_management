# frozen_string_literal: true

require_relative 'user'
require_relative 'email_validation'
require_relative 'password_validation'

class Authentication
  DB_USERS = 'db/user.yml'
  LOG_IN = 1
  SIGN_UP = 2
  UNAUTHOR = 3

  def initialize
    @user_list = Database.new(DB_USERS).load_file_with_permission(permission: User, crypt: BCrypt::Password)
    @current_user = nil
  end

  def call
    print_menu
    user_action = gets.chomp.to_i
    case user_action
    when LOG_IN
      login
    when SIGN_UP
      sign_up
    end

    @current_user
  end

  def login
    email = enter_email
    password = enter_password

    find_user_in_db(email, password)
    puts I18n.t('user.hello', user_email: @current_user.email).green unless @current_user.nil?
    @current_user
  end

  def sign_up
    email = enter_email
    return puts I18n.t('user.error.email').red unless EmailVallidation.valid?(email)

    setting_password(email)
    @current_user
  end

  private

  def print_menu
    puts I18n.t('user.menu.log_in', menu_option: LOG_IN).blue
    puts I18n.t('user.menu.sign_up', menu_option: SIGN_UP).blue
    puts I18n.t('user.menu.unauthor', menu_option: UNAUTHOR).blue
  end

  def enter_email
    puts I18n.t('user.email').blue
    gets.chomp
  end

  def enter_password
    puts I18n.t('user.password').blue
    $stdin.noecho(&:gets).chomp
  end

  def setting_password(email)
    password = enter_password
    return puts I18n.t('user.error.password') unless PasswordVallidation.valid?(password)

    create_and_save_new_user(email, password)
    puts I18n.t('user.hello', user_email: @current_user.email).green
  end

  def create_and_save_new_user(email, password)
    incrypted_password = BCrypt::Password.create(password)
    @current_user = User.new(email, incrypted_password)
    add_new_user_to_db
  end

  def add_new_user_to_db
    @user_list.push(@current_user)
    File.write(DB_USERS, @user_list.to_yaml)
  end

  def find_user_in_db(email, password)
    input_user = @user_list.find { |user| user.email == email }
    return puts I18n.t('user.error.user_exist').red if input_user.nil?
    return puts I18n.t('user.error.user_password') if input_user.password != password

    @current_user = input_user
  end
end
