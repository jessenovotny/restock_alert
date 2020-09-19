class GunBroker
  API_KEY = ENV['GUNBROKER_KEY']
  BASE_URI = ENV['GUNBROKER_URI']
  PASSWORD = ENV['GUNBROKER_PW']
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

  PAYMENT_METHODS = {
    Check: false,
    VisaMastercard: false,
    COD: false,
    Escrow: false,
    Amex: false,
    PayPal: true,
    Discover: false,
    SeeItemDesc: false,
    CertifiedCheck: false,
    USPSMoneyOrder: false,
    MoneyOrder: false,
    FreedomCoin: false
  }

  SHIPPING_METHODS = {
    Overnight: false,
    TwoDay: false,
    ThreeDay: false,
    Ground: false,
    FirstClass: false,
    Priority: true,
    Other: false
  }

  def self.create_listing(listing)
    payload = {
      CategoryID: 3016,
      CollectTaxes: false,
      Condition: 1,
      CountryCode: 'US',
      Description: 'listing.description',
      InspectionPeriod: 1,
      IsFFLRequired: false,
      ListingDuration: 5,
      PaymentMethods: PAYMENT_METHODS,
      PictureURLs: [ 'https://s3.amazonaws.com/backup-talend.appcohesion.io/DistributorMedia_S3/MSSBR-2NSQZKHI_LIP_MB65035.jpg' ], # listing.img_url
      Quantity: 1,
      PostalCode: 85282,
      ShippingClassCosts: { Priority: 10.00 },
      ShippingClassesSupported: SHIPPING_METHODS,
      StartingBid: 0.01,
      Title: 'listing.title',
      WhoPaysForShipping: 8,
      WillShipInternational: false
    }.to_json
    headers = {
      'X-DevKey' => API_KEY,
      'Content-Type' => 'multipart/form-data',
      'X-AccessToken' => access_token
    }
    binding.pry
    res = RestClient.post(BASE_URI + '/items', payload, headers)
    JSON.parse(res.body)
  end

end
