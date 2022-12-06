# frozen_string_literal: true

class Sort
  def initialize
    print I18n.t('sort.option').yellow
    @sort_option = gets.chomp.downcase
    print I18n.t('sort.direction').yellow
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