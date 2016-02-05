module SepaDate
  module Configure
    #
    # Location of the business time configuration file
    #
    @@business_time_configuration_file = "config/business_time.yml"

    #
    # Location of the holidays configuration file
    # This file holds the ECB holidays as well as national ones
    #
    @@holidays_configuration_file = "config/holidays.yml"

    #
    # Definition on how many days in advance should we need a bank file generated
    #
    @@instruction_days = 3

    #
    # ECB code that should be used when dealing with European wide bank holidays
    #
    @@ecb_code = "ecb"

    #
    # Country code, if any, that should be used when dealing with national holidays
    #
    @@country_code = nil

    def business_time_configuration_file
      @@business_time_configuration_file
    end

    def business_time_configuration_file=(business_time_configuration_file)
      @@business_time_configuration_file = business_time_configuration_file
    end

    def holidays_configuration_file
      @@holidays_configuration_file
    end

    def holidays_configuration_file=(holidays_configuration_file)
      @@holidays_configuration_file = holidays_configuration_file
    end

    def holidays_configuration
      YAML.load_file(@@holidays_configuration_file)
    end

    def instruction_days
      @@instruction_days
    end

    def instruction_days=(instruction_days)
      @@instruction_days = instruction_days
    end

    def ecb_code
      @@ecb_code
    end

    def ecb_code=(ecb_code)
      @@ecb_code = ecb_code
    end

    def country_code
      @@country_code
    end

    def country_code=(country_code)
      @@country_code = country_code
    end
  end
end
