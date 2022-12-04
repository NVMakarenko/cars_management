# frozen_string_literal: true

module Sort
  def sort(list)
    print I18n.t('sort.option').yellow
    sort_option = gets.chomp.downcase
    print I18n.t('sort.direction').yellow
    direction = gets.chomp.downcase
    return sort_price(list, direction) if sort_option == 'price'
    return list.sort_by!(&:date_added).reverse unless direction == 'asc'

    list.sort_by!(&:date_added)
  end

  def sort_price(list, direction)
    list.sort_by!(&:price)
    return list if direction == 'asc'

    list.reverse
  end
end
