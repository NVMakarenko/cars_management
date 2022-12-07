# frozen_string_literal: true

class OutputCarsTable
  TABLE_TITLE_STYLE = { border_bottom: false }.freeze

  def initialize(output_info)
    @output = output_info
  end

  def call
    table = Terminal::Table.new title: I18n.t('sort.table_header').black.on_green do |row|
      row.style = TABLE_TITLE_STYLE
      list_objects_into_table(row)
    end
    puts table
  end

  private

  def list_objects_into_table(row)
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

  def table_key(car_property)
    I18n.t('sort').find do |translation_access, _translation|
      translation_access.to_s == car_property
    end.last.green
  end
end
