class TwilioClient
  TWILIO_SID = ENV['TWILIO_SID']
  TWILIO_TOKEN = ENV['TWILIO_TOKEN']
  MAIN_LINE = '+18573016128'

  def self.client
    @client ||= Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
  end

  def self.sms(text, phone_number)
    client.messages.create(
      from: MAIN_LINE,
      to: phone_number,
      body: text
    )
  end
end
