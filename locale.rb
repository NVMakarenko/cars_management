# frozen_string_literal: true

class SetLocale
  WELCOME_STYLE = :red
  LOCALE_STYLE = :magenta

  def initialize
    I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
    puts I18n.t('welcome').colorize(WELCOME_STYLE)
  end

  def call
    puts (I18n.t('index.language').colorize(LOCALE_STYLE) + I18n.t('index.language',
                                                                   locale: :ua).colorize(LOCALE_STYLE)).underline
    user_locale = gets.chomp.downcase
    I18n.locale = user_locale if I18n.available_locales.map(&:to_s).include?(user_locale)
  end
end
