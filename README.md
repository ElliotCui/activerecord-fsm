# ActiveRecord::Fsm

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/activerecord/fsm`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-fsm'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord-fsm

## Usage

1. `YourClass` should has one column named `status`.  
2. `#fsm_define` will make `YourClass` inherited ApplicationRecord/ActiveRecord::Base using `ActiveRecord::Fsm`.  
3. `ActiveRecord::Fsm::Graph.defined_klasses` will show all the classes with `ActiveRecord::Fsm` used. Which you can do something like fsm monitor.  

```ruby
class FsmUsedClass < ApplicationRecord
  STATUS_1 = 1
  STATUS_2 = 2
  STATUS_3 = 3

  PERMIT_STATUS = [
    [STATUS_1, STATUS_2],
    [STATUS_2, STATUS_3],
    [STATUS_1, STATUS_3],
  ]

  fsm_define(PERMIT_STATUS)
end

ActiveRecord::Fsm::Graph.defined_klasses
# => [FsmUsedClass]

class FsmUnusedClass < ApplicationRecord
end

ActiveRecord::Fsm::Graph.defined_klasses
# => [FsmUsedClass]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activerecord-fsm.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
