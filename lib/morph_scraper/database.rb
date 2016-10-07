require 'morph_scraper/database/version'
require 'open-uri'

module MorphScraper
  # Copy a sqlite database from another morph scraper into the current one.
  class Database
    class Error < StandardError; end

    def initialize(scraper, api_key: ENV['MORPH_API_KEY'], force: false)
      @scraper = scraper
      @api_key = api_key
      @force = force
    end

    def copy
      raise Error, existing_scraper_error if File.exist?('data.sqlite') && !force?
      File.write('data.sqlite', scraper_database)
    end

    private

    attr_reader :scraper, :api_key, :force

    alias force? force

    def existing_scraper_error
      'data.sqlite already exists! ' \
        'Pass the `force` option to the constructor to overwrite.'
    end

    def scraper_database
      open("https://morph.io/#{scraper}/data.sqlite?key=#{api_key}").read
    end
  end
end
