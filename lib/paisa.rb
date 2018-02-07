require 'paisa/version'

module Paisa
  UNITS = {
      1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five',
      6 => 'six', 7 => 'seven', 8 => 'eight', 9 => 'nine', 0 => nil
  }

  TENS = {
      1 => {
          1 => 'eleven', 2 => 'twelve', 3 => 'thirteen', 4 => 'fourteen', 5 => 'fifteen',
          6 => 'sixteen', 7 => 'seventeen', 8 => 'eighteen', 9 => 'nineteen', 0 => 'ten'
      },
      2 => Hash.new {|_, k| ['twenty', UNITS[k]].compact.join(' ')},
      3 => Hash.new {|_, k| ['thirty', UNITS[k]].compact.join(' ')},
      4 => Hash.new {|_, k| ['forty', UNITS[k]].compact.join(' ')},
      5 => Hash.new {|_, k| ['fifty', UNITS[k]].compact.join(' ')},
      6 => Hash.new {|_, k| ['sixty', UNITS[k]].compact.join(' ')},
      7 => Hash.new {|_, k| ['seventy', UNITS[k]].compact.join(' ')},
      8 => Hash.new {|_, k| ['eighty', UNITS[k]].compact.join(' ')},
      9 => Hash.new {|_, k| ['ninety', UNITS[k]].compact.join(' ')},
      0 => UNITS
  }

  def self.format(paise, precision: 2)
    little_endian = paise.to_s.reverse.chars
    paise = little_endian.shift(2).reverse
    hundreds = little_endian.shift(3).reverse
    others = little_endian.each_slice(2).map(&:reverse).map(&:join)
    rupees = [others.reverse, hundreds.join].flatten.compact.join(',').rjust(1, '0')
    [rupees, paise.join.rjust(2, '0').slice(0, precision)].reject(&:empty?).join('.')
  end

  def self.format_with_sym(paise, precision: 2)
    [symbol, format(paise, precision: precision)].join
  end

  def self.symbol
    '₹'
  end


  def self.words(paise)
    little_endian = paise.to_s.reverse.chars
    paise = [little_endian.shift(2).map(&:to_i).reverse]
    hundreds = [little_endian.shift(3).map(&:to_i).reverse]
    others = little_endian.each_slice(2).map {|p| p.map(&:to_i)}.map(&:reverse)

    [paise, hundreds, others].flatten(1).reject(&:empty?).reduce([]) do |memo, section|
      label = ['paise', 'rupees', 'thousand', 'lakh', 'crore'][memo.size]
      case section.size
        when 1
          memo << [UNITS[section[0]], label].join(' ')
        when 2
          memo << [TENS[section[0]][section[1]], label].join(' ')
        when 3
          memo << ["#{UNITS[section[0]]} hundred and", TENS[section[1]][section[2]], label].join(' ')
        else
          # do nothing
      end
    end.to_a.reverse.join(', ')
  end
end

