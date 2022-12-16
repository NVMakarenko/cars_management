# frozen_string_literal: true

class Output
  TABLE_TITLE_STYLE = { border_bottom: false }.freeze

  def initialize(output_info)
    @output = output_info
  end

  def call
    return puts I18n.t('no_result').red if @output.empty?

    table = Terminal::Table.new title: I18n.t('sort.table_header').black.on_green do |row|
      row.style = TABLE_TITLE_STYLE
      list_cars_into_table(row) if @output.first.instance_of?(Car)
      list_requests_into_table(row) if @output.first.instance_of?(UserRequest)
    end
    puts table
  end

  private

  def list_cars_into_table(row)
    @output.each do |car|
      car.to_hash.each do |car_property, car_property_value|
        row << [table_key(car_property), car_property_value.to_s] unless car_property == 'date_added'
        if car_property == 'date_added'
          row << [I18n.t('sort.date_added').green,
                  car_property_value.strftime('%d/%m/%Y').to_s]
        end
      end
      row << :separator
    end
  end

  def list_requests_into_table(row)
    @output.each do |user_request|
      user_request.to_hash.each do |request_property, request_property_value|
        row << [table_key(request_property), request_property_value.to_s]
      end
      row << :separator
    end
  end

  def table_key(item_property)
    I18n.t('sort').find do |translation_access, _translation|
      translation_access.to_s == item_property
    end.last.green
  end
end
