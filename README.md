# motion_require

Allows you to use `require` in your RubyMotion apps just like you are used to. This allows you to use gems like you normally do and manage your
dependencies with Bundler.

## Installation

Use bundler like you normally do when writing your Ruby apps, and add this line to your application's Gemfile:

    gem 'motion_require'

And then execute:

    $ bundle

Then require it in your Rakefile by adding this line somewhere at the top:

    require 'motion_require'

So your Rakefile will look something like this:

```ruby
require "bundler/setup"

$:.unshift('/Library/RubyMotion/lib')
require 'motion/project'
require 'motion_require'

Motion::Project::App.setup do |app|
  app.name = 'KillerApp'
end
```

## Usage

Now you can use require in your application to specify the dependencies without having to maintain the compliation order in you Rakefile.
You can even require files from gems that are in you Gemfile.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
