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

  if __FILE__ == $PROGRAM_NAME
    require 'minitest/autorun'
    require 'webmock/minitest'
    require 'fileutils'

    describe MorphScraperDatabase do
      def with_tmp_dir(&block)
        Dir.mktmpdir do |tmp_dir|
          Dir.chdir(tmp_dir, &block)
        end
      end

      before do
        stub_request(:get, 'https://morph.io/chrismytton/denmark-folketing-wikidata/data.sqlite?key=secret')
          .to_return(body: 'remote data')
      end

      subject { MorphScraperDatabase.new('chrismytton/denmark-folketing-wikidata', api_key: 'secret') }

      it 'copies the remote database into the current directory' do
        with_tmp_dir do
          File.exist?('data.sqlite').must_equal false
          subject.copy
          File.exist?('data.sqlite').must_equal true
          File.read('data.sqlite').must_equal 'remote data'
        end
      end

      it "doesn't overwrite an existing database" do
        with_tmp_dir do
          FileUtils.touch('data.sqlite')
          -> { subject.copy }.must_raise MorphScraperDatabase::Error
        end
      end

      describe 'with force: true option' do
        subject { MorphScraperDatabase.new('chrismytton/denmark-folketing-wikidata', api_key: 'secret', force: true) }

        it 'overwrites an existing database' do
          with_tmp_dir do
            File.write('data.sqlite', 'existing')
            subject.copy
            File.read('data.sqlite').must_equal 'remote data'
          end
        end
      end
    end
  end
end
