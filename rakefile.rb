# frozen_string_literal: true

require 'faker'
require 'rake/clean'

require_relative 'config/autoload'
require_relative 'app/helpers/menu_constants'
Dir['app/helpers/*.rake'].each { |file| load file }
