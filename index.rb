# frozen_string_literal: true

require_relative 'autoload'

old_sync = $stdout.sync # cache old value
$stdout.sync = true # set mode to true

SetLocale.new.call
current_user = Authentication.new.call
Menu.new.call(current_user)

$stdout.sync = old_sync # restore old value
