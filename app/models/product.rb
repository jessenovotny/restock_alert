class Product < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = 'tbl7bAvgvC5N4HaIn'

  # attr reader/writer defs
  %w(
    url
    keyword
    keyword_count
    alerting
    alert_series_started_at
    updated_at
    last_alerted_at
    last_error_at
    last_error
    type
  ).each do |attribute|
    define_method(attribute) do
      self[attribute]
    end

    define_method(attribute + "=") do |new_value|
      self[attribute] = new_value
    end
  end

  def self.find_by_url url
    all(filter: "{url} = '#{url}'").first
  end

  def self.check_for_updates
    all.each &:check
  end

  def check
    # puts "CHECKING: #{self.url}"
    alert if self.keyword_count.present? && self.keyword_count != current_keword_count
    self.keyword_count = current_keword_count if self.keyword_count.blank?
    self.updated_at = Time.now
  rescue => e
    # puts e.message
    # puts self.url
    self.last_error_at = Time.now
    self.last_error = e.message
    # TwilioClient.sms "#{e.class}: #{e.message}|| URL: #{url}" if Rails.env.development?
  ensure
    save
  end

  def alert
    # puts "ALERTING: #{self.url}"
    send_text
    self.keyword_count = current_keword_count
    self.last_alerted_at = Time.now
  end

  def send_text
    TwilioClient.sms(url, phone_numbers)
    recipients&.each{ |r| r.update_last_alerted_at }
  end

  def phone_numbers
    recipients&.map(&:phone) || '+1 818-606-2469'
  end

  def recipients
    @recipients ||= User.by_type(type) if Rails.env.production?
  end

  def current_keword_count
    @current_keword_count ||= html.downcase.scan(/#{keyword.downcase}/).count
  end

  def html
    RestClient.get(url).body
  end
end
