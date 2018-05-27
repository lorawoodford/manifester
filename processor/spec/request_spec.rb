require 'spec_helper'

describe 'Manifester::Processor::Request' do
  def stub_status(url, status)
    stub_request(
      :any,
      url
    ).to_return(status: status)
  end

  let(:manifest) { "https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv" }

  describe 'Download' do
    it 'should download content to a temp file' do
      stub_request(:any, manifest).to_return(
        body: 'Z',
        status: 200,
        headers: { 'Content-Length' => 1 }
      )
      begin
        file = Manifester::Processor::Request.download(manifest)
        expect(File).to exist(file)
        expect(file).to be_instance_of(Tempfile)
      ensure
        file.close
        file.unlink
      end
    end
  end

  describe 'Status' do
    it 'should return 200 status for a successful request' do
      stub_status(manifest, 200)
      expect(Manifester::Processor::Request.get_status(manifest)).to eq 200
    end

    it 'should return 404 status for a not-found request' do
      stub_status(manifest, 404)
      expect(Manifester::Processor::Request.get_status(manifest)).to eq 404
    end

    it 'should return 523 status for an undetermined error request' do
      stub_request(:any, manifest).to_raise(Exception)
      expect(Manifester::Processor::Request.get_status(manifest)).to eq 523
    end
  end
end
