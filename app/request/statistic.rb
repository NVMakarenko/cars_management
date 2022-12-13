# frozen_string_literal: true

require_relative 'request'

class Statistic
  DB_REQUESTS = 'db/request_history.yml'
  DB_USER_REQUESTS = 'db/user_request.yml'

  def initialize(current_user:, search_result: nil, current_request: nil)
    @search_result = search_result
    @current_request = current_request
    @current_user = current_user
    @request_list = Database.new(DB_REQUESTS).load_file_with_permission(Request)
    @user_request_list = Database.new(DB_USER_REQUESTS).load_file_with_permission(UserRequest)
  end

  def call
    update_request_db
    update_user_request_db
    display_statistic
  end

  def show_user_search
    return if @current_user.nil?

    @user_request_list.select do |user_request|
      user_request.user == @current_user.email
    end
  end

  private

  def update_request_db
    @current_request.total_quantity = @search_result.size
    validate_uniq_request(@request_list, @current_request)
    Database.new(DB_REQUESTS).save(@request_list)
  end

  def update_user_request_db
    my_request = UserRequest.new(@current_request, @current_user)
    validate_uniq_request(@user_request_list, my_request)
    Database.new(DB_USER_REQUESTS).save(@user_request_list)
  end

  def validate_uniq_request(list_of_objects, current_object)
    catch :request_uniq do
      list_of_objects.each do |request|
        if request == (current_object) && request.instance_of?(Request)
          (request.request_quantity += 1)
          @current_request.request_quantity = request.request_quantity
        end
        throw :request_uniq if request == (current_object)
      end
      list_of_objects.push(current_object)
    end
  end

  def display_statistic
    table = Terminal::Table.new title: I18n.t('statistic.table_header').black.on_green do |t|
      t << [I18n.t('statistic.total_quantity').green, @current_request.total_quantity.to_s]
      t << [I18n.t('statistic.request_quantity').green, @current_request.request_quantity.to_s]
    end
    puts table
  end
end
