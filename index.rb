# frozen_string_literal: true

require_relative 'filter_sort'

old_sync = $stdout.sync # cache old value
$stdout.sync = true # set mode to true

puts 'Please select search rules.'
request = Request.new
search_result = FilterSort.new(request, 'db/db.yml').call
Statistic.new(search_result, request, 'db/request_history.yml').call

$stdout.sync = old_sync # restore old value
