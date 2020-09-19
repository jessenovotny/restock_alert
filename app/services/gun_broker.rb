class GunBroker
  API_KEY = ENV['GUNBROKER_KEY']
  BASE_URI = ENV['GUNBROKER_URI']
  PASSWORD = ENV['GUNBROKER_PW'] || '6Z2s4vaPw4eN'
  HEADERS = {
    'Content-Type' => 'application/json',
    'X-DevKey' => API_KEY
  }

  def self.access_token
    payload = {
      'username' => 'jeminovo',
      'password' => PASSWORD
    }.to_json
    headers = {
      'Content-Type' => 'application/json',
      'X-DevKey' => API_KEY
    }
    res = RestClient.post(BASE_URI + '/Users/AccessToken', payload, headers)
    JSON.parse(res.body)['accessToken']
  end

  def self.create_listing(listing)
    payload= {
      CategoryID: 3016, # Reloading Supplies
      CollectTaxes: false,
      Condition: 1, # Factory
      CountryCode: 'US',
      Description: listing.description,
      InspectionPeriod: 1, # AS/IS no returns
      IsFFLRequired: false,
      ListingDuration: 5,
      PaymentMethods: { GunBrokerPay: true },
      PictureURLs: [ listing.img_url ],
      Quantity: 1,
      PostalCode: 85282,
      ShippingClassCosts: { Priority: 10.00 },
      ShippingClassesSupported: { Priority: true },
      StartingBid: 0.01,
      Title: listing.title,
      WhoPaysForShipping: 8, # Buyer pays fixed amount
      WillShipInternational: false
    }.to_json
    headers = HEADERS.merge({
      'Content-Type' => 'multipart/form-data',
      'X-AccessToken' => access_token
    })
    binding.pry
    res = RestClient.post(BASE_URI + '/items', payload, headers)

    listing.update listing_id: JSON.parse(res.body)['id']
  end

end
