require 'paisa/version'

module Paisa
  def self.format(paise)
    base_string = paise.to_s
    formatted_string = paise.to_s.rjust(3, '0').insert(-3, '.')
    formatted_string = formatted_string.insert(-7, ',') if base_string.size > 5
    formatted_string = formatted_string.insert(-10, ',') if base_string.size > 7
    formatted_string = formatted_string.insert(-13, ',') if base_string.size > 9
    formatted_string
  end

  def self.format_with_sym(paise)
    [symbol, format(paise)].join
  end

  def self.symbol
    '₹'
  end
end
