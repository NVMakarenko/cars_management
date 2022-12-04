# frozen_string_literal: true

class OutputCarsTable
  TABLE_TITLE_STYLE = { color: :black, background: :green }.freeze
  TABLE_ROW_STYLE = :green

  def initialize(output_info)
    @output = output_info
  end

  def call
    table = Terminal::Table.new title: I18n.t('sort.table_header').colorize(TABLE_TITLE_STYLE) do |row|
      row.style = { border_bottom: false }
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
          row << [I18n.t('sort.date_added').colorize(TABLE_ROW_STYLE),
                  car_property_value.strftime('%d/%m/%Y').to_s]
        end
      end
      row << :separator
    end
  end

  def table_key(car_property)
    I18n.t('sort').filter_map do |translation_access, translation|
      translation if translation_access.to_s == car_property
    end.first.colorize(TABLE_ROW_STYLE)
  end
end
