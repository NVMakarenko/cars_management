# frozen_string_literal: true

require_relative 'request'

class Statistic
  DB_REQUESTS = 'db/request_history.yml'
  DB_USER_REQUESTS = 'db/user_request.yml'

  def initialize(user, search_result, current_request)
    @search_result = search_result
    @current_request = current_request
    @current_user = user
    @request_list = load_file(DB_REQUESTS, Request)
    @user_request_list = load_file(DB_USER_REQUESTS, UserRequest)
  end

  def call
    update_request_db
    update_user_request_db
    display_statistic
  end

  def show_user_search
    unless @current_user.nil?
      return @user_request_list.select do |user_request|
               user_request.user == @current_user.email
             end
    end

    @user_request_list.select { |user_request| user_request.user.nil? }
  end

  private

  def load_file(db_adress, permission)
    if File.exist?(db_adress)
      YAML.safe_load(File.open(db_adress), permitted_classes: [permission])
    else
      []
    end
  end

  def update_request_db
    @current_request.total_quantity = @search_result.size
    validate_uniq_request(@request_list, @current_request)
    File.write(DB_REQUESTS, @request_list.to_yaml)
  end

  def update_user_request_db
    my_request = UserRequest.new(@current_request, @current_user)
    validate_uniq_request(@user_request_list, my_request)
    File.write(DB_USER_REQUESTS, @user_request_list.to_yaml)
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
