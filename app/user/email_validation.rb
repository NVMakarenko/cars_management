# frozen_string_literal: true

class EmailVallidation
  DB_USERS = 'db/user.yml'

  attr_reader :email

  def initialize(email)
    @email = email
    if File.exist?(DB_USERS)
      @user_list = YAML.safe_load(File.open(DB_USERS),
                                  permitted_classes: [User, BCrypt::Password])
    end
    @user_list ||= []
  end

  def self.valid?(email)
    new(email).valid?
  end

  def valid?
    email_format_valid? &&
      email_length_valid? &&
      email_uniq?
  end

  private

  def email_length_valid?
    @email.split('@').first.length >= 5
  end

  def email_format_valid?
    @email.match?(URI::MailTo::EMAIL_REGEXP)
  end

  def email_uniq?
    @user_list.each { |user| return false if user.email == @email }
  end
end
