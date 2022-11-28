# frozen_string_literal: true

require 'i18n'
require 'colorize'
require_relative 'filter_sort'

old_sync = $stdout.sync # cache old value
$stdout.sync = true # set mode to true

I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
I18n.locale = :en # (note that `en` is already the default!)
puts I18n.t('index.language').magenta.underline + I18n.t('index.language', locale: :ua).magenta.underline
user_locale = gets.chomp.downcase
I18n.locale = user_locale if I18n.available_locales.map(&:to_s).include?(user_locale)

puts I18n.t('index.select_search_rules').light_magenta
request = Request.new
search_result = FilterSort.new(request, 'db/db.yml').call
Statistic.new(search_result, request, 'db/request_history.yml').call

$stdout.sync = old_sync # restore old value
