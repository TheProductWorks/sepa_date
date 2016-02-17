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

  #
  # is_sepa_date?/1
  #
  def test_is_sepa_date_with_sepa_date
    assert SepaDate.is_sepa_date?(@monday)
  end

  def test_is_sepa_date_with_sepa_date
    assert !SepaDate.is_sepa_date?(@paddys_day)
  end

  #
  # holidays_for_year/1
  #
  def test_holidays_for_year
    expected_holidays = ["2015-12-25", "2015-12-28", "2015-01-01", "2015-04-03", "2015-04-06", "2015-05-01", "2015-01-01", "2015-03-17", "2015-04-03", "2015-04-06", "2015-05-04", "2015-05-01", "2015-08-03", "2015-10-26", "2015-12-25", "2015-12-28", "2015-12-29"]
    holidays = SepaDate.holidays_for_year 2015

    assert_equal expected_holidays, holidays
  end

  #
  # ecb_holidays_for_year/1
  #
  def test_ecb_holidays_for_year_empty_set
    assert_equal [], SepaDate.ecb_holidays_for_year(2001)
  end

  #
  # national_holidays_for_year/1
  #
  def test_national_holidays_for_year_empty_set
    assert_equal [], SepaDate.national_holidays_for_year(2001)
  end

  def test_national_holidays_for_year_with_locale
    expected_holidays = ["2015-01-01", "2015-03-17", "2015-04-03", "2015-04-06", "2015-05-04", "2015-05-01", "2015-08-03", "2015-10-26", "2015-12-25", "2015-12-28", "2015-12-29"]
    assert_equal expected_holidays, SepaDate.national_holidays_for_year(2015, "ie")
  end

  #
  # verify_due_date/1
  #
  def test_verify_due_date__date_unchanged
    assert_equal @monday, SepaDate.verify_due_date(expected_due_date: @monday)
  end

  def test_verify_due_date__date_unchanged_verbose
    result = {due_date: @monday, message: "The selected payment date falls on an ECB date."}
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @monday, verbose: true)
  end

  def test_verify_due_date__date_end_of_month
    monday = DateTime.new(2015, 3, 2)
    result = DateTime.new(2015, 3, 31)
    assert_equal result, SepaDate.verify_due_date(expected_due_date: monday, end_of_month: true)
  end

  def test_verify_due_date__date_end_of_month_verbose
    monday = DateTime.new(2015, 3, 2)
    result = {due_date: DateTime.new(2015, 3, 31), message: "The selected payment date adjusted to the end of the month, falls on an ECB date."}
    assert_equal result, SepaDate.verify_due_date(expected_due_date: monday, end_of_month: true, verbose: true)
  end

  def test_verify_due_date__date_not_weekday
    result = DateTime.new(2015, 2, 2)
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @sunday)
  end

  def test_verify_due_date__date_not_weekday_verbose
    result = {due_date: DateTime.new(2015, 2, 2), message: "The selected payment date falls on a weekend. We will automatically adjust this to the next available banking day, 02/02/2015."}
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @sunday, verbose: true)
  end

  def test_verify_due_date__date_end_of_month_not_weekday
    result = DateTime.new(2015, 2, 27)
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @monday, end_of_month: true)
  end

  def test_verify_due_date__date_end_of_month_not_weekday_verbose
    result = {due_date: DateTime.new(2015, 2, 27), message: "The selected payment date falls on a weekend. We will automatically adjust this to the next available banking day, 27/02/2015."}
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @monday, end_of_month: true, verbose: true)
  end

  def test_verify_due_date__date_ecb_holiday
    result = DateTime.new(2015, 4, 7)
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @ecb_day)
  end

  def test_verify_due_date__date_ecb_holiday_verbose
    result = {due_date: DateTime.new(2015, 4, 7), message: "The selected payment date falls on a bank holiday. We will automatically adjust this to the next available banking day, 07/04/2015."}
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @ecb_day, verbose: true)
  end

  def test_verify_due_date__date_national_holiday
    result = DateTime.new(2015, 3, 18)
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @paddys_day)
  end

  def test_verify_due_date__date_national_holiday_verbose
    result = {due_date: DateTime.new(2015, 3, 18), message: "The selected payment date falls on a bank holiday. We will automatically adjust this to the next available banking day, 18/03/2015."}
    assert_equal result, SepaDate.verify_due_date(expected_due_date: @paddys_day, verbose: true)
  end

  def test_verify_due_date__date_s_submission_date_is_ecb_holiday
    day = SepaDate.submission_days.business_days.after(@ecb_day)
    result = DateTime.new(2015, 4, 13)
    assert_equal result, SepaDate.verify_due_date(expected_due_date: day)
  end

  def test_verify_due_date__date_s_submission_date_is_ecb_holiday
    day = SepaDate.submission_days.business_days.after(@ecb_day)
    result = {due_date: DateTime.new(2015, 4, 13), message: "The selected payment date cannot be fulfilled because the required bank submission date falls on a bank holiday. We will automatically adjust this to the next available banking day, 13/04/2015."}
    assert_equal result, SepaDate.verify_due_date(expected_due_date: day, verbose: true)
  end
end
