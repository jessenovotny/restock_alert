class User < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'tblTjATuyBJqCv6C4'

  # attribute defitions
  %w(
    name
    phone
    primers
    ammo
    last_alerted_at
    last_alert_url
  ).each do |attribute|
    define_method(attribute) do
      self[attribute]
    end

    define_method(attribute + "=") do |new_value|
      self[attribute] = new_value
    end
  end

  def self.by_type type
    all(filter: "NOT({#{type}} = '')")
  end

  def self.master
    all.find{ |u| u.name == 'jesse' }
  end

  def update_last_alerted url
    self.last_alert_url = url
    self.last_alerted_at = Time.now
    self.save
  end

  def send_text url
    TwilioClient.sms(url, phone)
    update_last_alerted(url)
  end
end
