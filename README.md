# ActiveRecord::Fsm

A simple Finite State Machine.  
Use this gem to auto define Finite State Machine on ActiveRecord with one column named `status`.  

**The goal of this gem is to monitor record with wrong state, and then help us to stats whether or not the code works well.**  
**The next step is to add monitor to FSM, and now it is currently UNDER DEVELOPMENT.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-fsm'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install activerecord-fsm

Maybe you need to do migration, add one column named `status`:

    bin/rails generate migration AddStatusToFsmModel status:integer:index  
    # or you can specify column type
    bin/rails generate migration AddStatusToFsmModel status:{column_type}:index

## Usage

1. Include `ActiveRecord::Fsm` into `ApplicationRecord/ActiveRecord::Base` or directly into `FsmModel`.  
2. Use `#fsm_define` to arrange permit_transitions set in which status can be transitioned from one to another. This will add:
    
        validates :status, presence: true, inclusion: { in: self.fsm_graph.states }
        validate :fsm_graph_check_permit_transitions, on: :update, if: :will_save_change_to_status?

    `fsm_graph_check_permit_transitions` has been defined as:
    ```
      def fsm_graph_check_permit_transitions
        unless self.class.fsm_graph.valid_transition?(*self.status_change)
          self.errors.add(:status, 'no permit status change')
          throw :abort
        end
      end
    ```
    **Model without using `fsm_define` will only act as the same with `NormalModel` which doesn't has fsm mechanic.**  
    In other words, using `fsm_define` will make `NormalModel` become `FsmModel`.

3. Use `FsmModel.fsm_graph.transitions` to get all permit_transition you defined.
4. Use `FsmModel.fsm_graph.states` to get all permit_status you defined.
5. Use `FsmModel.fsm_graph.final_states.include?(fsm_instance.status)` to judge FsmModel instance `fsm_instance` terminate?.
6. Use `ActiveRecord::Fsm::Graph.defined_klasses` to get all the models which really used `ActiveRecord::Fsm`.

e.g.  

```ruby
class ApplicationRecord < ActiveRecord::Base
  include ActiveRecord::Fsm

  self.abstract_class = true
  # blablabla......
end

# FsmModel need call fsm_define
class FsmModel < ApplicationRecord
  STATE_1 = 1
  STATE_2 = 2
  STATE_3 = 3

  PERMIT_TRANSITIONS = [
    [STATE_1, STATE_2],
    [STATE_2, STATE_3],
    [STATE_1, STATE_3],
  ]

  fsm_define(PERMIT_TRANSITIONS)
end

# FsmModel can be shown having used ActiveRecord::Fsm
ActiveRecord::Fsm::Graph.defined_klasses
# => [FsmModel]

# NormalModel doesn't call fsm_define
# although inherited from ApplicationRecord
class NormalModel < ApplicationRecord
end

# NormalModel is not included
ActiveRecord::Fsm::Graph.defined_klasses
# => [FsmModel]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activerecord-fsm.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
