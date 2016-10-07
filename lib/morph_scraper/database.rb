require 'morph_scraper/database/version'
require 'open-uri'

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
      IO.copy_stream(scraper_database.path, path)
    end

    private

    attr_reader :scraper, :api_key

    def scraper_database
      @scraper_database ||= Tempfile.new.tap do |tmp_file|
        IO.copy_stream(open("https://morph.io/#{scraper}/data.sqlite?key=#{api_key}"), tmp_file.path)
      end
    end
  end
end
