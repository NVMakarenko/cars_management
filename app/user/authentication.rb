# frozen_string_literal: true

require_relative 'user'
require_relative 'email_validation'
require_relative 'password_validation'

class Authentication
  DB_USERS = 'db/user.yml'

  def initialize
    if File.exist?(DB_USERS)
      @user_list = YAML.safe_load(File.open(DB_USERS),
                                  permitted_classes: [User, BCrypt::Password])
    end
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
    email = enter_email
    password = enter_password

    find_user_in_db(email, password)
    puts I18n.t('user.hello', user_email: @current_user.email).green unless @current_user.nil?
  end

  def sign_up
    email = enter_email
    return puts I18n.t('user.error.email').red unless EmailVallidation.valid?(email)

    setting_password(email)
    @current_user
  end

  private

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
