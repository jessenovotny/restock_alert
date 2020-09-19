class Listing < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'tbli1fhUX9iGKUOc8'

  KEYWORDS = 'Keywords: CCI 550 500 BR4 400 450 BR5 Federal 100 105 200 205 450 Remington 2 5 7 1/2 Winchester'
  
  # attr reader/writer defs
  %w(product end_date gun_broker_id brand type).each do |attr|
    define_method(attr) { self[attr] }
    define_method(attr + "=") { |new_v| self[attr] = new_v }
  end

  def self.sync_all
    all.each(&:sync)
  end

  def sync
    return if gun_broker_id
    listing = GunBroker.create_listing(self)
    self.gun_broker_id = listing['id']
    save
  end

  def description
    "#{title} #{KEYWORDS}"
  end

  def title
    "1000 x #{type.titleize} Primers #{product_info}" 
  end

  def img_url
    Product::ALL[brand][type][:img]
  end

  def product_info
    Product::ALL[brand][type][:info]
  end
end
