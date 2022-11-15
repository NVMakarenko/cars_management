# frozen_string_literal: true

require_relative 'search_rule'
include SearchRule
old_sync = $stdout.sync # cache old value
$stdout.sync = true # set mode to true

puts 'Please select search rules.'
request = Request.new
search_result = sort(filter(init_cars_list, request))
output(search_result)
statistic(search_result, request)
$stdout.sync = old_sync # restore old value
