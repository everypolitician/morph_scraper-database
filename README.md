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

### Replace your local `data.sqlite` with one from another scraper

**WARNING**: This will destroy any existing data in the current scraper's `data.sqlite` database, so make sure that you _actually_ want to do this!

#### Basic

Make sure your morph.io API key is set in the `MORPH_API_KEY` environment variable. Then you can overwrite the current `data.sqlite` by adding the following code to a scraper:

```ruby
require 'morph_scraper/database'
MorphScraper::Database.new('tmtmtmtm/malta-parliament').write(force: true)
```

**Note**: The above code will overwrite the database of the _current_ scraper with the contents of the _named_ scraper's database **every single time** this code is run. You might want to make this code conditional on an environment variable or remove it once you've used it, otherwise it will overwrite your database on each run and you can potentially lose data.

#### Advanced

If you require more control over the API key and the path that the database is written to:

```ruby
require 'morph_scraper/database'
scraper_db = MorphScraper::Database.new('tmtmtmtm/malta-parliament', api_key: 'replace_with_your_morph_api_key')
scraper_db.write(path: 'data.sqlite', force: true)
```

### Getting data from another scraper

In some situations you might just want to get a subset of the data from a remote scraper, or you might want to get all of the data and then merge it with the existing data that you have locally, for that you can use the `#data` and `#query` methods:

To get all the data from a table back as an array of hashes, use `Database#data`:

```ruby
require 'morph_scraper/database'
scraper_db = MorphScraper::Database.new('tmtmtmtm/malta-parliament')

# Equivalent to SELECT * FROM data;
scraper_db.data

# Equivalent to SELECT * FROM terms;
scraper_db.data(:terms)

# Or you can run a custom query
scraper_db.query('SELECT *, 5 as term FROM data LIMIT 10')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/everypolitician/morph_scraper-database.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
