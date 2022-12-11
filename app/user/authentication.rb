# frozen_string_literal: true

require_relative 'user'
require_relative 'validation_email'
require_relative 'validation_password'

class Authentication
  DB_USERS = 'db/user.yml'

  def initialize
    @user_list = YAML.safe_load(File.open('db/user.yml'), permitted_classes: [User, BCrypt::Password])
    @user_list ||= []
    @current_user = nil
  end

  def call
    puts
    I18n.t('user.menu').each_value { |menu_option| puts menu_option.blue }
    user_action = gets.chomp.to_i
    if user_action == 1
      login
    else
      sign_up
    end

    @current_user
  end

  def login
    email = enter_value(I18n.t('user.email'))
    input_user = @user_list.find { |user| user.email == email }
    return puts I18n.t('user.error.user_exist').red if input_user.nil?

    find_by_email_and_password(email)
  end

  def find_by_email_and_password(email)
    puts I18n.t('user.password').blue
    password = $stdin.noecho(&:gets).chomp
    input_user = @user_list.find { |user| user.email == email && user.password == password }
    return puts I18n.t('user.error.user_password') if input_user.nil?

    puts I18n.t('user.hello', user_email: input_user.email).green
    @current_user = input_user
  end

  def sign_up
    email = enter_value(I18n.t('user.email'))
    return puts I18n.t('user.error.email').red unless VallidationEmail.valid?(email)

    setting_password(email)
    @current_user
  end

  private

  def enter_value(value)
    puts value.blue
    gets.chomp
  end

  def setting_password(email)
    puts I18n.t('user.password')
    password = $stdin.noecho(&:gets).chomp
    return puts I18n.t('user.error.password') unless VallidationPassword.valid?(password)

    create_and_save_new_user(email, password)
    puts "#{I18n.t('user.hello')} #{@current_user.email}!".green
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
end
