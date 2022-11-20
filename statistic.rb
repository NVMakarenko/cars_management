# frozen_string_literal: true

require_relative 'request'

class Statistic
  def initialize(search_result, current_request, request_db)
    @search_result = search_result
    @current_request = current_request
    @request_list = YAML.safe_load(File.open(request_db), permitted_classes: [Request])
  end

  def call
    update_request_db
    display_statistic
  end

  private

  def update_request_db
    validate_uniq_request
    File.open('db/request_history.yml', 'w+') { |file| file.write(@request_list.to_yaml) }
  end

  def validate_uniq_request
    catch :request_uniq do
      @request_list.each do |request|
        if request == (@current_request)
          (request.request_quantity += 1)
          request.total_quantity = @search_result.size
          @current_request.request_quantity = request.request_quantity
        end
        throw :request_uniq if request == (@current_request)
      end
      @request_list.push(@current_request)
    end
  end

  def display_statistic
    puts '----------------------------------'
    puts 'Statistic'
    @current_request.total_quantity = @search_result.size
    puts "Total Quantity: #{@current_request.total_quantity}"
    puts "Request Quantity: #{@current_request.request_quantity}"
  end
end
