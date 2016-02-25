# Use this hook to configure date formats, config files and so forth.
SepaDate.configuration do |c|
  # Submission days buffer - business days it takes to process a payment from
  # a bank's point of view once they received a payment file.
  # c.submission_days = 6

  # Formatting for dates in all output messages.
  # c.date_format = "%d/%m/%Y"

  # Date format used to parse configuration options from the YAML files for holidays.
  # c.config_date_format = "%Y-%m-%d"

  # Location of the business time configuration file.
  c.business_time_configuration_file = "config/business_time.yml"

  # Location of the holidays configuration file. This file holds the ECB holidays as well as national ones.
  c.holidays_configuration_file = "config/holidays.yml"

  # Definition on how many days in advance should we need a bank file generated.
  # c.instruction_days = 3

  # ECB code that should be used when dealing with European wide bank holidays.
  c.ecb_code = "ecb"

  # Country code, if any, that should be used when dealing with national holidays.
  # Change this to the country code your application runs in for its payments.
  # Also make sure that the corresponding holidays.yml file is updated with the
  # relevant holidays.
  c.country_code = "ie"
end
