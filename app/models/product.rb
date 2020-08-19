class Product < Airrecord::Table
  self.base_key = ENV['AIRTABLE_APP_KEY']
  self.table_name = ENV['AIRTABLE_TABLE_NAME']

  # def self.due_for_check
  #   all.select do |r|
  #     r['alerting'].present? ||
  #       r['alert_series_started_at'].blank? ||
  #       Time.parse(r['alert_series_started_at']) < 1.day.ago
  #   end
  # end

  def self.find_by_url url
    all.find{|p|p.url == url}
  end

  ALERT_DURATION = 15 # minutes

  %w(url keyword keyword_count alerting alert_series_started_at).each do |attribute|
    define_method(attribute) do
      self[attribute]
    end

    define_method(attribute + "=") do |new_value|
      self[attribute] = new_value
    end
  end

  def check
    alert if keyword_count.present? && keyword_count != current_keword_count
    set_keyword_count if keyword_count.blank?
    save
    puts "CHECKING: #{self.url}"
  rescue => e
    TwilioClient.sms "#{e.class}: #{e.message}|| URL: #{url}" if Rails.env.development?
  end

  def set_keyword_count
    self.keyword_count = current_keword_count
  end

  def alert
    puts "ALERTING: #{self.url}"
    send_text
    set_keyword_count
    # self.alert_series_started_at ||= Time.now
    # self.alerting = (Time.now - alert_series_started_at) < ALERT_DURATION.minutes
  end

  def send_text
    TwilioClient.sms(url)
  end

  def current_keword_count
    html.downcase.scan(/#{keyword.downcase}/).count
  end

  def html
    @html ||= web_page.content
  end

  def web_page
    @web_page ||= Nokogiri::HTML(URI.open(url))
  end
end
