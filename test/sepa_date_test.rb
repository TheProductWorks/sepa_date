require 'test_helper'

class SepaDateTest < MiniTest::Unit::TestCase
  def setup
    # Setup the country code for Ireland
    SepaDate.configuration do |c|
      c.country_code = "ie"
    end

    @sunday = DateTime.new(2015, 2, 1)
    @monday = DateTime.new(2015, 2, 2)
    @last_workday = DateTime.new(2015, 1, 30)
    @ecb_day = DateTime.new(2015, 4, 3)
    @paddys_day = DateTime.new(2015, 3, 17)
  end

  #
  # adjust_weekend/2
  #
  def test_adjust_weekend_monday
    assert_equal @monday, SepaDate.adjust_weekend(@monday)
  end

  def test_adjust_weekend_sunday
    assert_equal @monday, SepaDate.adjust_weekend(@sunday)
  end

  def test_adjust_weekend_sunday_end_of_month
    assert_equal @last_workday, SepaDate.adjust_weekend(@sunday, true)
  end

  #
  # adjust_bank_holiday/2
  #
  def test_adjust_bank_holiday_non_holiday
    assert_equal @monday, SepaDate.adjust_bank_holiday(@monday)
  end

  def test_adjust_bank_holiday_ecb_holiday
    assert_equal DateTime.new(2015, 4, 6), SepaDate.adjust_bank_holiday(@ecb_day)
  end

  def test_adjust_bank_holiday_st_patrick_s_day
    assert_equal DateTime.new(2015, 3, 18), SepaDate.adjust_bank_holiday(@paddys_day)
  end

  def test_adjust_bank_holiday_ecb_holiday_end_of_month
    assert_equal DateTime.new(2015, 4, 2), SepaDate.adjust_bank_holiday(@ecb_day, true)
  end
end
