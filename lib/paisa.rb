# frozen_string_literal: true

require 'paisa/version'

module Paisa
  UNITS = {
      1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five',
      6 => 'six', 7 => 'seven', 8 => 'eight', 9 => 'nine', 0 => nil
  }.freeze

  TENS = {
      1 => {
          1 => 'eleven', 2 => 'twelve', 3 => 'thirteen', 4 => 'fourteen', 5 => 'fifteen',
          6 => 'sixteen', 7 => 'seventeen', 8 => 'eighteen', 9 => 'nineteen', 0 => 'ten'
      },
      2 => Hash.new do |_, k|
        ['twenty', UNITS[k]].compact.join(' ')
      end,
      3 => Hash.new do |_, k|
        ['thirty', UNITS[k]].compact.join(' ')
      end,
      4 => Hash.new do |_, k|
        ['forty', UNITS[k]].compact.join(' ')
      end,
      5 => Hash.new do |_, k|
        ['fifty', UNITS[k]].compact.join(' ')
      end,
      6 => Hash.new do |_, k|
        ['sixty', UNITS[k]].compact.join(' ')
      end,
      7 => Hash.new do |_, k|
        ['seventy', UNITS[k]].compact.join(' ')
      end,
      8 => Hash.new do |_, k|
        ['eighty', UNITS[k]].compact.join(' ')
      end,
      9 => Hash.new do |_, k|
        ['ninety', UNITS[k]].compact.join(' ')
      end,
      0 => UNITS
  }.freeze

  def self.format(paise, precision: 2)
    rupee_parts, paise_part = parse(paise)
    [
        rupee_parts.join(',').rjust(1, '0'),
        paise_part.rjust(2, '0').slice(0, precision)
    ].reject(&:empty?).join('.')
  end

  def self.format_with_sym(paise, precision: 2)
    [symbol, format(paise, precision: precision)].join
  end

  def self.symbol
    '₹'
  end

  def self.words(paise)
    rupee_parts, paise_part = parse(paise)
    rupee_text_parts = rupee_parts.reverse.each_with_object([]) do |section, memo|
      label = ['', ' thousand', ' lakh', ' crore'][memo.size]
      memo << if section.to_i.zero?
                nil
              else
                [to_words(section), label].join
              end
    end
    text = []
    text << [rupee_text_parts.to_a.compact.reverse.join(', '), 'rupees'].join(' ') unless rupee_text_parts.empty?
    text << [to_words(paise_part), 'paise'].join(' ') unless paise_part.to_i.zero?
    text.join(', ')
  end

  def self.parse(paise)
    little_endian = paise.to_s.reverse.chars
    paise_part = little_endian.shift(2).reverse.join
    rupee_parts = []
    cycle = [3, 2, 2].cycle
    until little_endian.empty?
      rupee_parts.unshift(little_endian.shift(cycle.next).reverse.join)
    end
    [rupee_parts, paise_part]
  end

  private_class_method :parse

  def self.to_words(section)
    digits = section.chars.map(&:to_i)
    case digits.size
      when 1
        UNITS[digits[0]]
      when 2
        TENS[digits[0]][digits[1]]
      when 3
        parts = []
        parts << [UNITS[digits[0]], 'hundred'].join(' ')
        parts << TENS[digits[1]][digits[2]] unless digits.slice(1, 2).sum.zero?
        parts.join(' and ')
      else
        # do nothing
    end
  end
end
