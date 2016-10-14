require 'morph_scraper/database/version'
require 'open-uri'
require 'json'

module MorphScraper
  # Copy a sqlite database from another morph scraper into the current one.
  class Database
    class Error < StandardError; end

    def initialize(scraper, api_key: ENV['MORPH_API_KEY'])
      @scraper = scraper
      @api_key = api_key
    end

    def write(path: 'data.sqlite', force: false)
      if File.exist?(path) && !force
        message = 'data.sqlite already exists! ' \
          'Pass the `force` option to the constructor to overwrite.'
        raise Error, message
      end
      File.write(path, scraper_database)
    end

    def data(table = :data)
      query("SELECT * FROM #{table}")
    end

    def query(sql)
      JSON.parse(morph_api_json(sql), symbolize_names: true)
    end

    private

    attr_reader :scraper, :api_key

    def scraper_database
      open("https://morph.io/#{scraper}/data.sqlite?key=#{api_key}").read
    end

    def morph_api_json(sql)
      open("https://api.morph.io/#{scraper}/data.json" \
           "?#{URI.encode_www_form(key: api_key, query: sql)}").read
    end
  end
end
