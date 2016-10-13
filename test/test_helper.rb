$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'morph_scraper/database'

require 'minitest/autorun'
require 'webmock/minitest'

module Minitest
  class Spec
    def with_tmp_dir(&block)
      Dir.mktmpdir do |tmp_dir|
        Dir.chdir(tmp_dir, &block)
      end
    end

    def stub_morph_query(scraper, query, key = 'secret')
      stub_request(:get, "https://api.morph.io/#{scraper}/data.json?#{URI.encode_www_form(key: key, query: query)}")
    end
  end
end
