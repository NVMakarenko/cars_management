# frozen_string_literal: true

class Sort
  SORT_STYLE = :yellow

  def initialize
    print I18n.t('sort.option').colorize(SORT_STYLE)
    @sort_option = gets.chomp.downcase
    print I18n.t('sort.direction').colorize(SORT_STYLE)
    @sort_direction = gets.chomp.downcase
  end

  def call(list)
    return sort_price(list) if @sort_option == 'price'
    return list.sort_by!(&:date_added).reverse unless @sort_direction == 'asc'

    list.sort_by!(&:date_added)
  end

  private

  def sort_price(list)
    list.sort_by!(&:price)
    return list if @sort_direction == 'asc'

    list.reverse
  end
end
