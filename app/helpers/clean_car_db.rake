# frozen_string_literal: true

namespace :db do
  include MenuConstants

  desc 'clean up db cars'
  task :clean_cars do
    Rake::Cleaner.cleanup(DB_CARS)
    File.open(DB_CARS, 'w')
    puts 'DB cleaned'
  end
end
