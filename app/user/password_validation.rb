# frozen_string_literal: true

class PasswordVallidation
  def initialize(password)
    @password = password
  end

  def self.valid?(password)
    new(password).valid?
  end

  def valid?
    password_length_valid? &&
      password_upper_valid? &&
      password_signs_valid?
  end

  private

  def password_length_valid?
    @password.length >= 8 && @password.length <= 20
  end

  def password_upper_valid?
    @password.match(/[[:upper:]]/)
  end

  def password_signs_valid?
    @password.match(/[[:^alnum:]]{2,}/)
  end
end
