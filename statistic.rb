# frozen_string_literal: true

require_relative 'request_quantity'

module Statistic
  def statistic(result)
    puts '----------------------------------'
    puts 'Statistic'
    @current_request.total_quantity = result.size
    puts "Total Quantity: #{@current_request.total_quantity}"
    request_list = YAML.safe_load(File.open('db/request.yml'), permitted_classes: [RequestQuantity])
    catch_uniq_request(request_list)
    File.open('db/request.yml', 'rb+') { |file| file.write(request_list.to_yaml) }
  end

  def catch_uniq_request(request_list)
    catch :request_uniq do
      request_list.each do |request|
        if request == (@current_request)
          (request.request_quantity += 1) &&
            (puts "Request Quantity: #{request.request_quantity}")
        end
        throw :request_uniq if request == (@current_request)
      end
      request_list.push(@current_request)
      puts "Request Quantity: #{@current_request.request_quantity}"
    end
  end
end
