SEPA Date Gem
=============

Determine based on holidays whether a date is an official [SEPA](https://www.ecb.europa.eu/paym/retpaym/paymint/html/index.en.html) payment date recognised by the European Central Bank (ECB). The gem populates the base [holidays](http://www.ecb.europa.eu/home/contacts/html/index.en.html#t5) for year 2015, 2016, 2017 and 2018 and will grab the later years' dates from  ECB's site (feature yet to be completed).

The SEPA Date gem can be configured to check for national holidays as well, which may differ from the official ECB holidays. To set these up, please consult

## Requirements

* Ruby >= 1.8.7

## Dependencies

The SEPA Date gem relies on the following gems:

* [holiday](https://rubygems.org/gems/holiday)
* [business_time](https://rubygems.org/gems/business_time)

Development depencies:

* [rake](https://rubygems.org/gems/rake)
* [minitest](https://rubygems.org/gems/minitest)

## Installation

Add this to your Gemfile and run the `bundle` command.

```ruby
gem "sepa_date"
```

## Usage

To test if your expected payment date is in fact a valid ECB day, and not a national holiday as well as it can be processed within a reasonable timeframe from the banks' point of view:

```ruby

due_date = SepaDate.verify_due_date(expected_due_date: DateTime.new(2015, 3, 18))
# due_date = #<Date: 2015-03-18 ((2457100j,0s,0n),+0s,2299161j)>

```

The library will auto-adjust should your payment date fall on a holiday or a weekend:

```ruby

due_date = SepaDate.verify_due_date(expected_due_date: DateTime.new(2015, 4, 3))
# due_date = #<Date: 2015-04-07 ((2457100j,0s,0n),+0s,2299161j)>

```

The library will provide you useful information about these adjustments if it applied some adjustion in `verbose` mode:


```ruby

due_date = SepaDate.verify_due_date(expected_due_date: DateTime.new(2015, 4, 3), verbose: true)
# due_date = {due_date: #<Date: 2015-04-07 ((2457100j,0s,0n),+0s,2299161j)>, message: "The selected payment date cannot be fulfilled because the required bank submission date falls on a bank holiday. We will automatically adjust this to the next available banking day, 07/04/2015."}

```

## Configuration

### How to add national holidays?

### How to add national holidays?

## Contributing

## License

(The MIT License)

Copyright (c) 2014 Máté Marjai, The Product Works

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
