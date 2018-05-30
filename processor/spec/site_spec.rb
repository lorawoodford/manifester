require 'spec_helper'

describe 'Site' do
  let(:data) do
    {
      site: 'demo',
      manifest: 'https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv',
      name: 'LYRASIS',
      contact: 'Mark Cooper',
      email: 'example@example.com',
      timezone: 'America/New_York'
    }
  end

  before(:each) do
    stub_request(
      :head,
      'https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv'
    ).to_return(status: 200, body: '', headers: {})
  end

  it 'should not be found until created' do
    expect(
      Manifester::Processor::Site.new(data).exists?
    ).to be nil
  end

  it 'should persist and retrieve a new site' do
    site = Manifester::Processor::Site.new(data).create!
    expect(site.site).to eq 'demo'
  end

  it 'should not allow duplicate sites to be created' do
    site = Manifester::Processor::Site.new(data).create!
    expect(Manifester::Processor::Site.find(:site, 'demo').count).to eq 1
  end

  it 'should be able to find a site by correct name' do
    expect(Manifester::Processor::Site.find(:name, 'LYRASIS').count).to eq 1
  end

  it 'should not be able to find a site by incorrect name' do
    expect(Manifester::Processor::Site.find(:name, 'ABCXYZ').count).to eq 0
  end

  it 'should be able to delete a site' do
    expect(Manifester::Processor::Site.delete!('demo').count).to eq 1
  end
end
