require "rails_helper"

RSpec.describe MusicBrainzService do
  subject(:service) { described_class.new }

  describe "#lookup" do
    context "when the artist exists", :vcr do
      it "returns a hash with name and id" do
        result = service.lookup("Radiohead")

        expect(result[:name]).to eq("Radiohead")
        expect(result[:id]).to be_present
      end
    end

    context "when no artist matches", :vcr do
      it "raises NotFoundError" do
        expect { service.lookup("xyznonexistentartist12345") }
          .to raise_error(MusicBrainzService::NotFoundError)
      end
    end

    context "when the API returns a 503" do
      it "raises ServiceError" do
        stub_request(:get, /musicbrainz\.org/)
          .to_return(status: 503)

        expect { service.lookup("Radiohead") }
          .to raise_error(MusicBrainzService::ServiceError, /503/)
      end
    end
  end
end
