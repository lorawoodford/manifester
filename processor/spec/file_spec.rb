require 'spec_helper'
require 'ostruct'

describe 'File' do
  let(:site) {
    OpenStruct.new(:site => 'demo', :timezone => 'America/Los_Angeles')
  }
  let(:data) {
    {
      location: "https://archivesspace.lyrasistechnology.org/files/exports/0246.001.xml",
      title: "Papers",
      deleted: "false",
      updated_at: "24-May-2018 22:00",
    }
  }
  let(:timestamp) { 1527224400 }

  it 'should not be found until created' do
    expect(
      Manifester::Processor::File.new(site, data).exists?
    ).to be nil
  end

  it 'should persist and retrieve a new file' do
    file = Manifester::Processor::File.new(site, data).create!
    expect(file.site).to eq site.site
    expect(file.title).to eq data[:title]
    expect(file.timestamp).to eq timestamp
  end

  it 'should not allow duplicate files to be created' do
    file = Manifester::Processor::File.new(site, data).create!
    expect(Manifester::Processor::File.find(:url, data[:location]).count).to eq 1
  end

  it 'should be able to find a file by correct title' do
    expect(Manifester::Processor::File.find(:title, data[:title]).count).to eq 1
  end

  it 'should not be able to find a file by incorrect title' do
    expect(Manifester::Processor::File.find(:title, 'ABCXYZ').count).to eq 0
  end

  it 'should not require an update with default data' do
    file = Manifester::Processor::File.new(site, data)
    file.refresh
    expect(file.requires_update?).to be false
  end

  it 'should require an update with deleted attribute update' do
    file = Manifester::Processor::File.new(site, data.merge({ deleted: 'true' }))
    file.refresh
    expect(file.requires_update?).to be true
  end

  it 'should require an update with updated_at attribute update' do
    file = Manifester::Processor::File.new(site, data.merge({ updated_at: '25-May-2018 22:00' }))
    file.refresh
    expect(file.requires_update?).to be true
  end

  it 'should be able to delete a file' do
    expect(Manifester::Processor::File.delete!(data[:location]).count).to eq 1
  end
end
