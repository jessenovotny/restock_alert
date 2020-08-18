class TwilioClient
  TWILIO_SID = ENV['TWILIO_SID']
  TWILIO_TOKEN = ENV['TWILIO_TOKEN']

  def self.client
    @client ||= Twilio::REST::Client.new TWILIO_SID, TWILIO_TOKEN
  end

  def self.sms(text)
    client.messages.create(
      from: '+18573016128',
      to: '+18186062469',
      body: text
    )
  end
end
