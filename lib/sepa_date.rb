require 'sepa_date/configure'

module SepaDate
  extend Configure

  #
  # == adjustion on bank holidays
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
    bank_holidays = SepaDate.holidays_configuration

    holidays = bank_holidays[SepaDate.ecb_code][date.year]
    if SepaDate.country_code
      holidays += bank_holidays[SepaDate.country_code][date.year]
    end
    date_string = date.strftime('%Y-%m-%d')

    if holidays.include?(date_string)
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
  # == adjustion on weekend days
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
