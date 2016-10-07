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

    def create_database(data)
      Tempfile.new('morph_scraper-database:test_helper').tap do |tmp_file|
        db = Sequel.sqlite(tmp_file.path)
        data.each do |table, rows|
          db.create_table(table) do
            rows.first.keys.each { |key| String key }
          end
          rows.each { |row| db[table.to_sym].insert(row) }
        end
      end
    end
  end
end
