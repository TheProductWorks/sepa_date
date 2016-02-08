require 'test_helper'

class SepaDateTest < MiniTest::Unit::TestCase
  def setup
    @sunday = DateTime.new(2015, 2, 1)
    @monday = DateTime.new(2015, 2, 2)
    @last_workday = DateTime.new(2015, 1, 30)
  end

  def test_correct_weekend_monday
    assert_equal @monday, SepaDate.correct_weekend(@monday)
  end

  def test_correct_weekend_sunday
    assert_equal @monday, SepaDate.correct_weekend(@sunday)
  end

  def test_correct_weekend_sunday_end_of_month
    assert_equal @last_workday, SepaDate.correct_weekend(@sunday, true)
  end
end
