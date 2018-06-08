# Paisa

Having trouble figuring out where to put the commas in Indian money? Are you being lazy and defaulting to hundreds of thousands and millions instead of lakhs and crores? Default no more! `Paisa` is here to save you.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paisa'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paisa

## Usage

```

// Format paise - if you have your money in Rupees, multiply by 100 to get the number of paise.
Paisa.format(12345) // "123.45"
Paisa.format(12345678) // "1,23,456.78"
Paisa.format(12345678987) // "12,34,56,789.87"
Paisa.format(10000) // "100"

// Use formatWithSymbol to get Paisa to add the official Rupee symbol for you
Paisa.format_with_sym(12345678) // "₹1,23,456.78"
Paisa.format_with_sym(10000) // "₹100"

// Pass an optional second parameter to force decimal precision to be set. 
Paisa.format(12345678987, precision: 0) // "12,34,56,789" 
Paisa.format(10000, precision: 2) // "100.00"
Paisa.format_with_sym(10000, precision: 2) // "₹100.00"

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/paisa.rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

