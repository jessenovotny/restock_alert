class Product < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = ENV['AIRTABLE_TABLE_NAME']

  %w(url keyword keyword_count alerting alert_series_started_at updated_at last_alerted_at last_error_at last_error).each do |attribute|
    define_method(attribute) do
      self[attribute]
    end

    define_method(attribute + "=") do |new_value|
      self[attribute] = new_value
    end
  end

  def self.find_by_url url
    all.find{|p|p.url == url}
  end

  def self.check_for_updates
    all.each &:check
  end

  def check
    return if self.updated_at && Time.now - Time.parse(self.updated_at) < 1.day
    puts "CHECKING: #{self.url}"
    alert if keyword_count.present? && keyword_count != current_keword_count
    self.keyword_count = current_keword_count if keyword_count.blank?
    self.updated_at = Time.now
    save
  rescue => e
    # binding.pry if e.message.include? "no implicit conversion"
    puts e.message
    puts self.url
    self.last_error_at = Time.now
    self.last_error = e.message
    # TwilioClient.sms "#{e.class}: #{e.message}|| URL: #{url}" if Rails.env.development?
  ensure
    save
  end

  def alert
    puts "ALERTING: #{self.url}"
    send_text
    self.keyword_count = current_keword_count
    self.last_alerted_at = Time.now
  end

  def send_text
    TwilioClient.sms(url)
  end

  def current_keword_count
    @current_keword_count ||= html.downcase.scan(/#{keyword.downcase}/).count
  end

  def html
    RestClient.get(url).body
  end
end
