# Matreska

Matreska is for building adaptable multi-filter, which is inspired by Rack.

## Installation

Add this line to your application's Gemfile:

    gem 'matreska'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install matreska

## Usage

    mat = Matreska.build(1)
    Matreska.doll(:Plus) { |base, arg| base.map { |i| i + arg } }
    Matreska.doll(:Multi) { |base, arg| base.map { |i| i * arg } }
    mat.set Plus, 3
    mat.set Multi, 2

    mat.call #=> 8

## Contributing

1. Fork it ( http://github.com/<my-github-username>/matreska/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
