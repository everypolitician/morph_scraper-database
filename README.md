# MorphScraperDatabase

This class allows you to copy the SQLite database from another morph.io scraper
into the current scraper. This is useful when you transfer a morph.io between
GitHub account and want to retain the data from the original scraper (which
we've been doing a lot as part of the
[EveryPolitician project](http://everypolitician.org/)).

## Usage

First download a copy of [morph_scraper_database.rb](morph_scraper_database.rb)
from this repo into your scraper. Then require it and use it:

```ruby
require_relative './morph_scraper_database'
MorphScraperDatabase.new('tmtmtmtm/malta-parliament', api_key: 'replace_with_your_morph_api_key').copy
```

This will copy the given scraper's `data.sqlite` into the current scraper.
