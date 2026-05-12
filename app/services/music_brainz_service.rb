require "net/http"
require "json"

class MusicBrainzService
  BASE_URL = "https://musicbrainz.org/ws/2"
  USER_AGENT = "MusicApiExt/1.0 (https://github.com/imtiaz-abbas/music-api-ext)"

  class NotFoundError < StandardError; end
  class ServiceError < StandardError; end

  def lookup(name)
    uri = URI("#{BASE_URL}/artist/")
    uri.query = URI.encode_www_form(query: "artist:#{name}", fmt: "json")

    response = get(uri)

    raise ServiceError, "HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    body = JSON.parse(response.body)
    artist = body["artists"]&.first

    raise NotFoundError, "No artist found for '#{name}'" if artist.nil?

    {
      id: artist["id"],
      name: artist["name"],
      country: artist["country"],
      disambiguation: artist["disambiguation"]
    }
  end

  private

  def get(uri)
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      request = Net::HTTP::Get.new(uri)
      request["User-Agent"] = USER_AGENT
      request["Accept"] = "application/json"
      http.request(request)
    end
  rescue SocketError, Errno::ECONNREFUSED, Net::OpenTimeout, Net::ReadTimeout => e
    raise ServiceError, e.message
  end
end
