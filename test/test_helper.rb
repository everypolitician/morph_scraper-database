$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'morph_scraper/database'

require 'minitest/autorun'
require 'webmock/minitest'
require 'pry'

module Minitest
  class Spec
    def with_tmp_dir(&block)
      Dir.mktmpdir do |tmp_dir|
        Dir.chdir(tmp_dir, &block)
      end
    end
  end
end
