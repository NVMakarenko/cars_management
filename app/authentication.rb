# frozen_string_literal: true

require 'bcrypt'
require_relative 'user'

class Authentication
  DB_USERS = 'db/user.yml'
  EMAIL_REQUIREMENTS = /\A([\w.+-]{5,})+@[\w.]{2,}\z/
  PASSWOORD_REQUIREMENTS = /^(?=.*[A-Z])(?=(.*[[:^alnum:]]){2}).{8,20}$/

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
    email = enter_email
    return puts I18n.t('user.error.email_length') unless validate_email_length(email)
    return puts I18n.t('user.error.email_uniq') unless validate_email_uniq(email)

    setting_password(email)
    @current_user
  end

  private

  def setting_password(email)
    password = enter_password
    return puts I18n.t('user.error.password') unless validate_password(password)

    incrypted_password = BCrypt::Password.create(password)
    @current_user = User.new(email, incrypted_password)
    add_new_user(@current_user)
  end

  def add_new_user(current_user)
    @user_list.push(current_user)
    File.write(DB_USERS, @user_list.to_yaml)
    puts "#{I18n.t('user.hello')} #{@current_user.email}!"
  end

  def validate_email_length(email)
    email =~ EMAIL_REQUIREMENTS
  end

  def validate_email_uniq(email)
    @user_list.each { |user| return false if user.email == email }
  end

  def validate_password(password)
    password =~ PASSWOORD_REQUIREMENTS
  end
end
