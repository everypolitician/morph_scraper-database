require 'test_helper'

describe MorphScraper::Database do
  it 'has a version number' do
    ::MorphScraper::Database::VERSION.wont_be_nil
  end

  before do
    stub_request(:get, 'https://morph.io/chrismytton/denmark-folketing-wikidata/data.sqlite?key=secret')
      .to_return(body: 'remote data')
  end

  subject { MorphScraper::Database.new('chrismytton/denmark-folketing-wikidata', api_key: 'secret') }

  it 'copies the remote database into the current directory' do
    with_tmp_dir do
      File.exist?('data.sqlite').must_equal false
      subject.write
      File.exist?('data.sqlite').must_equal true
      File.read('data.sqlite').must_equal 'remote data'
    end
  end

  it "doesn't overwrite an existing database" do
    with_tmp_dir do
      FileUtils.touch('data.sqlite')
      -> { subject.write }.must_raise MorphScraper::Database::Error
    end
  end

  describe 'with force: true option' do
    subject { MorphScraper::Database.new('chrismytton/denmark-folketing-wikidata', api_key: 'secret') }

    it 'overwrites an existing database' do
      with_tmp_dir do
        File.write('data.sqlite', 'existing')
        subject.write(force: true)
        File.read('data.sqlite').must_equal 'remote data'
      end
    end
  end

  describe '#data' do
    let(:scraper_slug) { 'everypolitician-scrapers/test-example' }
    let(:api_response) { [{ id: 1, name: 'Alice' }, { id: 2, name: 'Bob' }] }
    subject { MorphScraper::Database.new(scraper_slug, api_key: 'secret') }

    before do
      @morph_api_query = stub_morph_query(scraper_slug, 'SELECT * FROM data')
                         .to_return(body: api_response.to_json)
    end

    it 'returns the contents of the data table with no arguments' do
      subject.data.must_equal api_response
      assert_requested @morph_api_query
    end
  end
end
