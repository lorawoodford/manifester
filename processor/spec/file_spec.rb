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
  let(:updated_at) { Time.now }
  let(:updated_at_timestamp) { updated_at.to_i }

  before(:each) do
    stub_request(
      :head,
      "https://archivesspace.lyrasistechnology.org/files/exports/0246.001.xml"
    ).to_return(status: 200, body: "", headers: {})
  end

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

  it 'should be able to find a file by date' do
    expect(Manifester::Processor::File.find('timestamp.gte', timestamp).count).to eq 1
  end

  it 'should not be able to find a file by a later date' do
    expect(Manifester::Processor::File.find('timestamp.gte', updated_at_timestamp).count).to eq 0
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
    file = Manifester::Processor::File.new(site, data.merge({ updated_at: updated_at.to_s }))
    file.refresh
    expect(file.requires_update?).to be true
  end

  it 'should update file' do
    file = Manifester::Processor::File.new(site, data)
    file = file.create!
    expect(file.timestamp).to eq timestamp
    file = Manifester::Processor::File.new(site, data.merge({ updated_at: updated_at.to_s }))
    file.refresh
    file = file.update!
    expect(file.timestamp).to eq updated_at_timestamp
  end

  it 'should be able to find a file by the updated date' do
    expect(Manifester::Processor::File.find('timestamp.gte', updated_at_timestamp).count).to eq 1
  end

  it 'should be able to find a file using since timestamp' do
    expect(Manifester::Processor::File.since(timestamp).count).to eq 1
  end

  it 'should be able to find a file using since timestamp and yield' do
    Manifester::Processor::File.since(timestamp) do |file|
      expect(file.title).to eq data[:title]
    end
  end

  it 'should not be able to find a file using since timestamp with bad status' do
    file = Manifester::Processor::File.since(timestamp).first
    file.status = 404
    file.save
    expect(Manifester::Processor::File.since(timestamp).count).to eq 0
  end

  it 'should be able to delete a file' do
    expect(Manifester::Processor::File.delete!(data[:location]).count).to eq 1
  end
end
