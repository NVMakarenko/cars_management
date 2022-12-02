# frozen_string_literal: true

module OutputCarsTable
  def init_cars_list(cars_db)
    cars_list = YAML.load_file(cars_db)
    cars_list.map { |car| Car.new(car) }
  end

  def output(result)
    table = Terminal::Table.new title: I18n.t('sort.table_header').black.on_green do |row|
      row.style = { border_bottom: false }
      list_objects_into_table(result, row)
    end
    puts table
  end

  def list_objects_into_table(result, row)
    result.each do |car|
      car.to_hash.each do |key, value|
        row << [table_key(key), value.to_s] unless key == 'date_added'
        row << [I18n.t('sort.date_added').green, value.strftime('%d/%m/%Y').to_s] if key == 'date_added'
      end
      row << :separator
    end
  end

  def table_key(key)
    I18n.t('sort').filter_map { |k, v| v if k.to_s == key }.first.green
  end
end
