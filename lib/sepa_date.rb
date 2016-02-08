require 'sepa_date/configure'

module SepaDate
  extend Configure

  #
  # == Get SEPA date from an expected date when the payment is due
  #
  # Check if the date is a SEPA date, if it is not, adjust accordingly
  #
  # === Attributes
  #
  #  +expected_due_date+
  #  +verbose+ - boolean whether we should return extra information about the date adjustments, if any occurred
  #
  def self.verify_due_date expected_due_date, verbose = false
  end


  #
  # == Check if date is a day when SEPA payments can be processed
  #
  # Check if it is a weekday and it is not on the ECB and local holiday list
  #
  # === Attributes
  #
  # +date+
  #
  def self.is_sepa_date? date
    date.weekday? && !SepaDate.holidays_for_year(date.year).include?(date.strftime('%Y-%m-%d'))
  end

  #
  # == Return the holidays registered for passed in year
  #
  # === Attributes
  #
  # +year+
  #
  def self.holidays_for_year year
    return SepaDate.ecb_holidays_for_year(year) + SepaDate.national_holidays_for_year(year)
  end

  #
  # == National holidays for year and country
  #
  # === Attributes
  #
  # +year+
  # +country_code+
  #
  def self.national_holidays_for_year year, country_code = nil
    country_code ||= SepaDate.country_code
    return SepaDate.holidays_configuration[country_code][year] || []
  end

  #
  # == ECB holidays for year
  #
  # === Attributes
  #
  # +year+
  #
  def self.ecb_holidays_for_year year
    return SepaDate.holidays_configuration[SepaDate.ecb_code][year] || []
  end

  #
  # == Adjust bank holidays
  #
  # If a date falls on a bank holiday, let it be an ECB day, or a national holiday,
  # we automatically adjust it to the next available working day
  #
  # === Attributes
  #
  # +date+ - Date we want to check
  # +end_of_month+ - Boolean on whether we need to adjust the date to the end of the month
  #
  def self.adjust_bank_holiday(date, end_of_month=false)
    holidays = SepaDate.holidays_for_year(date.year)
    date_string = date.strftime('%Y-%m-%d')

    if !SepaDate.is_sepa_date?(date)
      if end_of_month
        while holidays.include?(date_string)
          date = 1.business_day.before(date)
          date_string = date.to_s
        end
      else
        while holidays.include?(date_string)
          date = 1.business_day.after(date)
          date_string = date.to_s
        end
      end
    end

    return date
  end

  #
  # == Adjust weekend days
  #
  # If a date falls on a weekend,
  # we automatically adjust it to the next available working day
  #
  # === Attributes
  #
  # +date+ - Date we want to check
  # +end_of_month+ - Boolean on whether we need to adjust the date to the end of the month
  #
  def self.adjust_weekend(date, end_of_month=false)
    if !date.weekday?
      if end_of_month
        date = 0.business_day.before(date)
      else
        date = 0.business_day.after(date)
      end
    end

    return date
  end
end
