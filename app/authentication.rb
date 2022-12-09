# frozen_string_literal: true

require_relative 'user'

class Authentication
  DB_USERS = 'db/user.yml'

  def initialize
    @user_list = YAML.safe_load(File.open(DB_USERS), permitted_classes: [User, BCrypt::Password])
    @user_list ||= []
    @current_user = nil
  end

  def call
    puts
    I18n.t('user.menu').each_value { |menu_option| puts menu_option.blue }
    user_action = gets.chomp.to_i
    login if user_action == 1
    sign_up unless user_action == 1

    @current_user
  end

  def login
    email = enter_value(I18n.t('user.email'))
    input_user = @user_list.find { |user| user.email == email }
    return puts I18n.t('user.error.user_exist') if input_user.nil?

    find_by_email_and_password(email)
  end

  def find_by_email_and_password(email)
    password = enter_value(I18n.t('user.password'))
    input_user = @user_list.find { |user| user.email == email && user.password == password }
    return puts I18n.t('user.error.user_password') if input_user.nil?

    puts "#{I18n.t('user.hello')} #{input_user.email}!"
    @current_user = input_user
  end

  def enter_value(value)
    puts value
    gets.chomp
  end

  def sign_up
    email = enter_value(I18n.t('user.email'))
    return invalid_email_message(email) unless email_valid?(email)

    setting_password(email)
    @current_user
  end

  private

  def setting_password(email)
    password = enter_value(I18n.t('user.password'))
    return invalid_password_message(password) unless password_valid?(password)

    incrypted_password = BCrypt::Password.create(password)
    @current_user = User.new(email, incrypted_password)
    add_new_user
  end

  def add_new_user
    @user_list.push(@current_user)
    File.write(DB_USERS, @user_list.to_yaml)
    puts "#{I18n.t('user.hello')} #{@current_user.email}!"
  end

  def password_valid?(password)
    password_length_valid?(password) &&
      password_upper_valid?(password) &&
      password_signs_valid?(password)
  end

  def invalid_password_message(password)
    puts I18n.t('user.error.password_length') unless password_length_valid?(password)
    puts I18n.t('user.error.password_upper') unless password_upper_valid?(password)
    puts I18n.t('user.error.password_signs') unless password_signs_valid?(password)
  end

  def password_length_valid?(password)
    password.length >= 8 && password.length <= 20
  end

  def password_upper_valid?(password)
    password.match(/[[:upper:]]/)
  end

  def password_signs_valid?(password)
    password.match(/[[:^alnum:]]{2,}/)
  end

  def email_valid?(email)
    email_format_valid?(email) &&
      email_length_valid?(email) &&
      email_uniq?(email)
  end

  def invalid_email_message(email)
    puts I18n.t('user.error.email_format') unless email_format_valid?(email)
    puts I18n.t('user.error.email_length') unless email_length_valid?(email)
    puts I18n.t('user.error.email_uniq') unless email_uniq?(email)
  end

  def email_length_valid?(email)
    email.split('@').first.length >= 5
  end

  def email_format_valid?(email)
    email.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def email_uniq?(email)
    @user_list.each { |user| return false if user.email == email }
  end
end
