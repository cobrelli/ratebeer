class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, :expires_in => 1.hour) { fetch_places_in(city) }
  end

  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.fetch_place(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/#{id}"
    response = HTTParty.get url
    place = response.parsed_response["bmp_locations"]["location"]
    second_url = "http://beermapping.com/webservice/locscore/#{key}/#{id}"
    response_score = HTTParty.get second_url
    place_score = response_score.parsed_response["bmp_locations"]["location"]
    return Place.new(name: place["name"], blogmap: place["blogmap"], zip: place["zip"], city: place["city"], street: place["street"], overall: place_score["overall"])
  end

  def self.key
    #"bbf0dec4c8ddcd8b60d772cd2b1f56c0"
    Settings.beermapping_apikey
  end
end