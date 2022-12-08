# frozen_string_literal: true

class User
  attr_accessor :email, :password

  def initialize(email, password)
    @email = email
    @password = password
  end

  def ==(other)
    email == other.email && password == other.password
  end
end
