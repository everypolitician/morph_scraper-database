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

  describe 'getting data out' do
    let(:database) do
      create_database(
        data:  [
          { test: 'foo' },
        ],
        names: [
          { name: 'Alice' },
          { name: 'Bob' },
        ]
      )
    end

    before do
      stub_request(:get, 'https://morph.io/chrismytton/denmark-folketing-wikidata/data.sqlite?key=secret')
        .to_return(body: database.read)
    end

    it 'returns the data table' do
      subject.data.must_equal [{ test: 'foo' }]
    end

    it 'returns other tables' do
      subject.data('names').must_equal [{ name: 'Alice' }, { name: 'Bob' }]
    end

    it 'allows arbitraty SQL queries' do
      expected = [{ name: 'ALICE', term: 5 }, { name: 'BOB', term: 5 }]
      subject.query('select upper(name) name, 5 as term from names').must_equal expected
    end
  end
end
