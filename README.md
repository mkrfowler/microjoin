# Microjoin

Microjoin strips out some repetition from cases where you're doing relational algebra in plain Ruby. For some reason.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'microjoin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install microjoin

## Usage

The whole thing reduces to queries such as the following:
```ruby
Microjoin::([1,2,3], [2,3,4]).inner.on { |v| v }
# {
#   2 => [ [2], [2] ],
#   3 => [ [3], [3] ]
# }
Microjoin::([1,2,3], [[2],[3],[4]]).outer.on(left: -> (v) { v }, right: -> (arr) { arr[0] })
# {
#   1 => [ [1], [   ] ],
#   2 => [ [2], [[2]] ],
#   3 => [ [3], [[3]] ],
#   4 => [ [ ], [[4]] ]
# }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mkrfowler/microjoin. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

