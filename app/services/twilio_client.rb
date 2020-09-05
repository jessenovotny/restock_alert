class TwilioClient
  TWILIO_SID = ENV['TWILIO_SID']
  TWILIO_TOKEN = ENV['TWILIO_TOKEN']
  MAIN_LINE = '+18573016128'

  def self.phone_numbers
    Rails.env.production? ? User : '+1 818-606-2469'
  end

  def self.client
    @client ||= Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
  end

  def self.sms(text, phone_numbers)
    client.messages.create(
      from: MAIN_LINE,
      to: phone_numbers,
      body: text
    )
  end
end
