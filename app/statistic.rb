# frozen_string_literal: true

require_relative 'request'

class Statistic
  def initialize(search_result, current_request, request_db)
    @search_result = search_result
    @current_request = current_request
    @request_list = YAML.safe_load(File.open(request_db), permitted_classes: [Request])
    @request_list ||= []
  end

  def call
    update_request_db
    display_statistic
  end

  private

  def update_request_db
    @current_request.total_quantity = @search_result.size
    validate_uniq_request
    File.write('db/request_history.yml', @request_list.to_yaml)
  end

  def validate_uniq_request
    catch :request_uniq do
      @request_list.each do |request|
        if request == (@current_request)
          (request.request_quantity += 1)
          @current_request.request_quantity = request.request_quantity
        end
        throw :request_uniq if request == (@current_request)
      end
      @request_list.push(@current_request)
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
