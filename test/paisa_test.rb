require 'test_helper'

class PaisaTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Paisa::VERSION
  end

  def test_simple_formatting
    assert_equal '3.34', Paisa.format(334)
    assert_equal '9,393.34', Paisa.format(939_334)
    assert_equal '92,83,83,393.34', Paisa.format(92_838_339_334)
    assert_equal '92,83,83,393.34', Paisa.format(92_838_339_334)
    assert_equal '2,83,83,393.34', Paisa.format(2_838_339_334)
    assert_equal '83,83,393.34', Paisa.format(838_339_334)
    assert_equal '3,83,393.34', Paisa.format(38_339_334)
    assert_equal '83,393.34', Paisa.format(8_339_334)
    assert_equal '393.34', Paisa.format(39_334)
    assert_equal '0.03', Paisa.format(3)
    assert_equal '0.50', Paisa.format(50)
    assert_equal '0.00', Paisa.format(0)
  end

  def test_format_with_sym
    assert_equal '₹', Paisa.symbol
    assert_equal '₹3.34', Paisa.format_with_sym(334)
    assert_equal '₹9,393.34', Paisa.format_with_sym(939_334)
    assert_equal '₹92,83,83,393.34', Paisa.format_with_sym(92_838_339_334)
    assert_equal '₹2,83,83,393.34', Paisa.format_with_sym(2_838_339_334)
    assert_equal '₹83,83,393.34', Paisa.format_with_sym(838_339_334)
    assert_equal '₹3,83,393.34', Paisa.format_with_sym(38_339_334)
    assert_equal '₹83,393.34', Paisa.format_with_sym(8_339_334)
    assert_equal '₹393.34', Paisa.format_with_sym(39_334)
    assert_equal '₹0.03', Paisa.format_with_sym(3)
    assert_equal '₹0.50', Paisa.format_with_sym(50)
    assert_equal '₹0.00', Paisa.format_with_sym(0)
  end
end
