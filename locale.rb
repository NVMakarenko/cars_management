# frozen_string_literal: true

class SetLocale
  def initialize
    I18n.load_path += Dir["#{File.expand_path('config/locales')}/*.yml"]
    puts I18n.t('welcome').red
  end

  def call
    puts (I18n.t('index.language').magenta + I18n.t('index.language',
                                                    locale: :ua).magenta).underline
    user_locale = gets.chomp.downcase
    I18n.locale = user_locale if I18n.available_locales.map(&:to_s).include?(user_locale)
  end
end
