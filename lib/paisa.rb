require 'paisa/version'

module Paisa
  def self.format(paise)
    little_endian = paise.to_s.reverse.chars
    paise = little_endian.shift(2).reverse
    hundreds = little_endian.shift(3).reverse
    others = little_endian.each_slice(2).map(&:reverse).map(&:join)
    rupees = [others.reverse, hundreds.join].flatten.compact.join(',').rjust(1, '0')
    [rupees, paise.join.rjust(2, '0')].join('.')
  end

  def self.format_with_sym(paise)
    [symbol, format(paise)].join
  end

  def self.symbol
    '₹'
  end
end
