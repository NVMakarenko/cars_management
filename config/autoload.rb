# frozen_string_literal: true

require 'bcrypt'
require 'colorize'
require 'date'
require 'i18n'
require 'io/console'
require 'terminal-table'
require 'uri'
require 'yaml'

Dir['./app/*.rb'].each { |file| require file }
Dir['./app/car/*.rb'].each { |file| require file }
Dir['./app/request/*.rb'].each { |file| require file }
Dir['./app/user/*.rb'].each { |file| require file }

require_relative 'locale'
