require 'test_helper'

class PaisaTest < Minitest::Test
  def test_version_number
    refute_nil ::Paisa::VERSION
  end

  def test_simple_formatting
    assert_equal '3.34', Paisa.format(334)
    assert_equal '9,393.34', Paisa.format(939_334)
    assert_equal '792,83,83,393.34', Paisa.format(792_838_339_334)
    assert_equal '92,83,83,393.34', Paisa.format(92_838_339_334)
    assert_equal '2,83,83,393.34', Paisa.format(2_838_339_334)
    assert_equal '83,83,393.34', Paisa.format(838_339_334)
    assert_equal '3,83,393.34', Paisa.format(38_339_334)
    assert_equal '83,393.34', Paisa.format(8_339_334)
    assert_equal '393.34', Paisa.format(39_334)
    assert_equal '0.03', Paisa.format(3)
    assert_equal '0.50', Paisa.format(50)
    assert_equal '0.00', Paisa.format(0)
    assert_equal '393.3', Paisa.format(39_334, precision: 1)
    assert_equal '393', Paisa.format(39_334, precision: 0)
  end

  def test_format_with_sym
    assert_equal '₹', Paisa::SYMBOL
    assert_equal '₹3.34', Paisa.format_with_sym(334)
    assert_equal '₹9,393.34', Paisa.format_with_sym(939_334)
    assert_equal '₹92,83,83,393.34', Paisa.format_with_sym(92_838_339_334)
    assert_equal '₹192,83,83,393.34', Paisa.format_with_sym(192_838_339_334)
    assert_equal '₹2,83,83,393.34', Paisa.format_with_sym(2_838_339_334)
    assert_equal '₹83,83,393.34', Paisa.format_with_sym(838_339_334)
    assert_equal '₹3,83,393.34', Paisa.format_with_sym(38_339_334)
    assert_equal '₹83,393.34', Paisa.format_with_sym(8_339_334)
    assert_equal '₹393.34', Paisa.format_with_sym(39_334)
    assert_equal '₹393.3', Paisa.format_with_sym(39_334, precision: 1)
    assert_equal '₹393', Paisa.format_with_sym(39_334, precision: 0)
    assert_equal '₹0.03', Paisa.format_with_sym(3)
    assert_equal '₹0.50', Paisa.format_with_sym(50)
    assert_equal '₹0.00', Paisa.format_with_sym(0)
  end

  def test_words
    assert_equal 'forty two paise', Paisa.words(42)
    assert_equal 'two paise', Paisa.words(2)
    assert_equal 'ten paise', Paisa.words(10)
    assert_equal 'fifteen paise', Paisa.words(15)
    assert_equal 'ninety two paise', Paisa.words(92)
    assert_equal 'two rupees, ninety two paise', Paisa.words(292)
    assert_equal 'twenty eight rupees, thirty seven paise', Paisa.words(2837)
    assert_equal 'nine hundred and twenty three rupees, forty eight paise', Paisa.words(92348)
    assert_equal 'eight thousand, four hundred and sixty two rupees, twenty seven paise', Paisa.words(846227)
    assert_equal 'fifty seven thousand, two hundred and two rupees, seventy four paise', Paisa.words(5720274)
    assert_equal 'seven lakh, seventy five thousand, one hundred and ninety three rupees, eighty five paise', Paisa.words(77519385)
    assert_equal 'sixty seven lakh, seventy five thousand, one hundred and ninety three rupees, eighty five paise', Paisa.words(677519385)
    assert_equal 'eight crore, sixty seven lakh, seventy five thousand, one hundred and ninety three rupees, eighty five paise', Paisa.words(8677519385)
    assert_equal 'eighteen crore, sixty seven lakh, seventy five thousand, one hundred and ninety three rupees, eighty five paise', Paisa.words(18677519385)
    assert_equal 'seven hundred and eighteen crore, sixty seven lakh, seventy five thousand, one hundred and ninety three rupees, eighty five paise', Paisa.words(718677519385)
    assert_equal 'three hundred rupees', Paisa.words(300_00)
    assert_equal 'fifty thousand rupees', Paisa.words(5000000)
    assert_equal 'five lakh rupees', Paisa.words(50000000)
    assert_equal 'five crore rupees', Paisa.words(5000000000)
    assert_equal 'five crore, forty two lakh rupees', Paisa.words(5420000000)
    assert_equal 'five crore, forty two lakh rupees, seventy four paise', Paisa.words(5420000074)
  end
end
