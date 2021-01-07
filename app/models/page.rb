class Page < Airrecord::Table
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
    all(sort: { "url" => "asc" }).each &:check
  end

  def check
    # puts "CHECKING: #{self.url}"
    alert if self.keyword_count.present? && self.keyword_count != current_keyword_count
    self.keyword_count = current_keyword_count if self.keyword_count.blank?
  rescue => e
    # puts e.message
    # puts self.url
    self.last_error_at = Time.now
    self.last_error = e.message
    # TwilioClient.sms "#{e.class}: #{e.message}|| URL: #{url}" if Rails.env.development?
  ensure
    self.updated_at = Time.now
    save
  end

  def alert
    # puts "ALERTING: #{self.url}"
    recipients&.each do |r|
      r.send_text(url)
    end
    self.keyword_count = current_keyword_count
    self.last_alerted_at = Time.now
  end

  def recipients
    @recipients ||= Rails.env.production? ? User.by_type(type) : [User.master]
  end

  def current_keyword_count
    @current_keyword_count ||= html.downcase.scan(/#{keyword.downcase}/).count
  end

  def html
    RestClient.get(url).body
  end
end
