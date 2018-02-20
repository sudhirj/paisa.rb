# frozen_string_literal: true

require 'paisa/version'

module Paisa
  SYMBOL = '₹'
  ONES = {
    1 => 'one', 2 => 'two', 3 => 'three', 4 => 'four', 5 => 'five',
    6 => 'six', 7 => 'seven', 8 => 'eight', 9 => 'nine', 0 => nil
  }.freeze

  def self.tens_hash(tens_name)
    Hash.new do |_, k|
      [tens_name, ONES[k]].compact.join(' ')
    end
  end

  private_class_method :tens_hash

  TENS = {
    1 => {
      1 => 'eleven', 2 => 'twelve', 3 => 'thirteen', 4 => 'fourteen', 5 => 'fifteen',
      6 => 'sixteen', 7 => 'seventeen', 8 => 'eighteen', 9 => 'nineteen', 0 => 'ten'
    },
    2 => tens_hash('twenty'),
    3 => tens_hash('thirty'),
    4 => tens_hash('forty'),
    5 => tens_hash('fifty'),
    6 => tens_hash('sixty'),
    7 => tens_hash('seventy'),
    8 => tens_hash('eighty'),
    9 => tens_hash('ninety'),
    0 => ONES
  }.freeze

  TENS_HIND = {
      1 => {
        1 => 'ग्यारह', 2 => 'बारह', 3 => 'तेरह', 4 => 'चौदह', 5 => 'पंद्रह', 6 => 'सोलह', 7 => 'सत्रह', 8 => 'अठारह', 9 => 'उन्नीस', 0 => 'दस'
      },
      2 => {
        1 => 'इकीस', 2 => 'बाईस', 3 => 'तेइस', 4 => 'चौबीस', 5 => 'पच्चीस', 6 => 'छब्बीस', 7 => 'सताइस', 8 => 'अट्ठाइस', 9 => 'उनतीस', 0 => 'बीस'
      },
      3 => {
        1 => 'इकतीस', 2 => 'बतीस', 3 => 'तैंतीस', 4 => 'चौंतीस', 5 => 'पैंतीस', 6 => 'छतीस', 7 => 'सैंतीस', 8 => 'अड़तीस', 9 => 'उनतालीस', 0 => 'तीस'
      },
      4 => {
        1 => 'इकतालीस', 2 => 'बयालीस', 3 => 'तैतालीस', 4 => 'चवालीस', 5 => 'पैंतालीस', 6 => 'छयालिस', 7 => 'सैंतालीस', 8 => 'अड़तालीस', 9 => 'उनचास', 0 => 'चालीस'
      },
      5 => {
        1 => 'इक्यावन', 2 => 'बावन', 3 => 'तिरपन', 4 => 'चौवन', 5 => 'पचपन', 6 => 'छप्पन', 7 => 'सतावन', 8 => 'अठावन', 9 => 'उनसठ', 0 => 'पचास'
      },
      6 => {
        1 => 'इकसठ', 2 => 'बासठ', 3 => 'तिरसठ', 4 => 'चौंसठ', 5 => 'पैंसठ', 6 => 'छियासठ', 7 => 'सड़सठ', 8 => 'अड़सठ', 9 => 'उनहतर', 0 => 'साठ'
      },
      7 => {
        1 => 'इकहतर', 2 => 'बहतर', 3 => 'तिहतर', 4 => 'चौहतर', 5 => 'पचहतर', 6 => 'छिहतर', 7 => 'सतहतर', 8 => 'अठहतर', 9 => 'उन्नासी', 0 => 'सत्तर'
      },
      8 => {
        1 => 'इक्यासी', 2 => 'बयासी', 3 => 'तिरासी', 4 => 'चौरासी', 5 => 'पचासी', 6 => 'छियासी', 7 => 'सतासी', 8 => 'अट्ठासी', 9 => 'नवासी', 0 => 'अस्सी'
      },
      9 => {
        1 => 'इक्यानवे', 2 => 'बानवे', 3 => 'तिरानवे', 4 => 'चौरानवे', 5 => 'पचानवे', 6 => 'छियानवे', 7 => 'सतानवे', 8 => 'अट्ठानवे', 9 => 'निन्यानवे', 0 => 'नब्बे'
      },
      0 => {
        1 => 'एक', 2 => 'दो', 3 => 'तीन', 4 => 'चार', 5 => 'पांच', 6 => 'छह', 7 => 'सात', 8 => 'आठ', 9 => 'नौ', 0 => nil
      }
    }.freeze

  def self.format(paise, precision: 2)
    rupee_parts, paise_part = parse(paise)
    [
      rupee_parts.join(',').rjust(1, '0'),
      paise_part.rjust(2, '0').slice(0, precision)
    ].reject(&:empty?).join('.')
  end

  def self.format_with_sym(paise, precision: 2)
    [SYMBOL, format(paise, precision: precision)].join
  end

  def self.words(paise, lang)
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
      ONES.dig(*digits)
    when 2
      TENS.dig(*digits)
    when 3
      parts = []
      parts << [ONES[digits[0]], 'hundred'].join(' ')
      parts << TENS.dig(*digits.slice(1, 2)) unless digits.slice(1, 2).inject(0){|sum,x| sum + x }.zero?
      parts.join(' and ')
    else
      # do nothing
    end
  end

  private_class_method :to_words
end
