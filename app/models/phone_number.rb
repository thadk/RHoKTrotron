class PhoneNumber < ActiveRecord::Base
  attr_accessible :country_code, :number


  def self.send_sms_message_to_number(message_body, to_number)
    twilio_client = Twilio::REST::Client.new ENV['TWILIO_SID'] || TWILIO_SID , ENV['TWILIO_TOKEN'] || TWILIO_TOKEN

    twilio_client.account.sms.messages.create(
      :from => "+1#{ENV['TWILIO_PHNONE_NUMBER'] || TWILIO_PHNONE_NUMBER}",
      :to => to_number,
      :body => message_body
    )
  end

end
