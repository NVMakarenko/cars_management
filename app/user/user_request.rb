# frozen_string_literal: true

class UserRequest < Request
  attr_accessor :make, :model, :year_from, :year_to, :price_from, :price_to, :user

  def initialize(request, user)
    request_part(request)
    @user = if user.nil?
              nil
            else
              user.email
            end
  end

  private

  def request_part(request)
    @make = request.make
    @model = request.model
    @year_from = request.year_from
    @year_to = request.year_to
    @price_from = request.price_from
    @price_to = request.price_to
  end
end
