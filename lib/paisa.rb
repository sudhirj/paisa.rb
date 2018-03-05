# frozen_string_literal: true

require 'paisa/version'

module Paisa
  SYMBOL = '₹'.freeze
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

  HINDI_MAPPING = {
    one:'एक', two: 'दो', three: 'तीन', four: 'चार', five: 'पांच', six: 'छह', seven: 'सात', zero: 'शून्य',
    eight: 'आठ', nine: 'नौ', ten: 'दस', eleven: 'ग्यारह', twelve: 'बारह', thirteen: 'तेरह', fourteen: 'चौदह', fifteen: 'पंद्रह',
    sixteen: 'सोलह', seventeen: 'सत्रह', eighteen: 'अठारह', 'nineteen': 'उन्नीस', hundred: 'सौ', thousand: 'हजार',
    lakh: 'लाख', crore: 'करोड़', rupees: 'रुपये', paise: 'पैसे', and: 'और',
    twenty: {
      one: 'इकीस', two: 'बाईस', three: 'तेइस', four: 'चौबीस', five: 'पच्चीस', six: 'छब्बीस', seven: 'सताइस',
      eight: 'अट्ठाइस', nine: 'उनतीस', zero: 'बीस'
    },
    thirty: {
      one: 'इकतीस', two: 'बतीस', three: 'तैंतीस', four: 'चौंतीस', five: 'पैंतीस', six: 'छतीस', seven: 'सैंतीस', eight: 'अड़तीस',
      nine: 'उनतालीस', zero: 'तीस'
    },
    forty: {
      one: 'इकतालीस', two: 'बयालीस', three: 'तैतालीस', four: 'चवालीस', five: 'पैंतालीस', six: 'छयालिस', seven: 'सैंतालीस',
      eight: 'अड़तालीस', nine: 'उनचास', zero: 'चालीस'
    },
    fifty: {
      one: 'इक्यावन', two: 'बावन', three: 'तिरपन', four: 'चौवन', five: 'पचपन', six: 'छप्पन', seven: 'सतावन', eight: 'अठावन',
      nine: 'उनसठ', zero: 'पचास'
    },
    sixty: {
      one: 'इकसठ', two: 'बासठ', three: 'तिरसठ', four: 'चौंसठ', five: 'पैंसठ', six: 'छियासठ', seven: 'सड़सठ',
      eight: 'अड़सठ', nine: 'उनहतर', zero: 'साठ'
    },
    seventy: {
      one: 'इकहतर', two: 'बहतर', three: 'तिहतर', four: 'चौहतर', five: 'पचहतर', six: 'छिहतर', seven: 'सतहतर',
      eight: 'अठहतर', nine: 'उन्नासी', zero: 'सत्तर'
    },
    eighty: {
      one: 'इक्यासी', two: 'बयासी', three: 'तिरासी', four: 'चौरासी', five: 'पचासी', six: 'छियासी', seven: 'सतासी',
      eight: 'अट्ठासी', nine: 'नवासी', zero: 'अस्सी'
    },
    ninety: {
      one: 'इक्यानवे', two: 'बानवे', three: 'तिरानवे', four: 'चौरानवे', five: 'पचानवे', six: 'छियानवे', seven: 'सतानवे',
      eight: 'अट्ठानवे', nine: 'निन्यानवे', zero: 'नब्बे'
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

  def self.words(paise, lang="english")
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
    case lang
    when "hindi"
      return hindi(text.join(', '))
    else
      return text.join(', ')
    end
  end

  def self.hindi(english)
    h = nil
    english.split(', ').map { | x | x.split.map do | k |
      if HINDI_MAPPING[k.to_sym].is_a? Hash
        h = HINDI_MAPPING[k.to_sym]
      else
        hindi_number = h.nil? ? HINDI_MAPPING[k.to_sym] : (h[k.to_sym].nil? ? [h[:zero], HINDI_MAPPING[k.to_sym]].join(' ') : h[k.to_sym])
        h = nil
      end
      hindi_number
      end.compact.join(' ')
    }.join(', ')
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
      parts << TENS.dig(*digits.slice(1, 2)) unless digits.slice(1, 2).all?(&:zero?)
      parts.join(' and ')
    else
      # do nothing
    end
  end

  private_class_method :to_words
end
