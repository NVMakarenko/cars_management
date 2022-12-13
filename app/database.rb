# frozen_string_literal: true

class Database
  def initialize(db_adress)
    @db_adress = db_adress
  end

  def load_file
    YAML.load_file(@db_adress)
  end

  def load_file_with_permission(permission)
    if File.exist?(@db_adress)
      YAML.safe_load(File.open(@db_adress), permitted_classes: [permission])
    else
      []
    end
  end

  def save(data)
    File.write(@db_adress, data.to_yaml)
  end
end
