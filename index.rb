# frozen_string_literal: true

require_relative 'search_engine'
include SearchRule
old_sync = $stdout.sync # cache old value
$stdout.sync = true # set mode to true

puts 'Please select search rules.'

output(sort(filter(init_cars_list)))

$stdout.sync = old_sync # restore old value
