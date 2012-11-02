# ThreadVariables

This gem provides methods to access thread local variables with a ruby trunk compatible
API. It also provides an implementation of thread local variables for ruby 1.9, since ruby
1.9 made thread locals fiber local. This change in semantics can lead to surprising
results when accessing thread locals from enumerators.

See http://bugs.ruby-lang.org/issues/7097


## Installation

Add this line to your application's Gemfile:

    gem 'thread_variables'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thread_variables

## Usage

    require "thread_variables"
    Thread.current.thread_variable_set :foo, 5
    Thread.current.thread_variable_get :foo
    Thread.current.thread_variable? :foo
    Thread.current.thread_variables

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
