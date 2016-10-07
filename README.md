# MorphScraper::Database

This class allows you to copy the SQLite database from another morph.io scraper
into the current scraper. This is useful when you transfer a morph.io between
GitHub account and want to retain the data from the original scraper (which
we've been doing a lot as part of the
[EveryPolitician project](http://everypolitician.org/)).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'morph_scraper-database'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install morph_scraper-database

## Usage

*WARNING*: This will destroy any existing data in the current scraper's `data.sqlite` database, so make sure that you _actually_ want to do this!

To *overwrite* the contents of the current scraper's database, run the following:

```ruby
require_relative 'morph_scraper/database'
scraper_db = MorphScraper::Database.new('tmtmtmtm/malta-parliament', api_key: 'replace_with_your_morph_api_key')
scraper_db.write(path: 'data.sqlite', force: true)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/morph_scraper-database.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

