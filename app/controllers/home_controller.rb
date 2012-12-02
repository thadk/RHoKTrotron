class HomeController < ApplicationController
  def index

  end

  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say 'Stop wasting time! Welcome to Tro-tron!', :voice => 'man'
    end

    render :xml => response.text
  end

  def sms
    message_body = params["Body"]
    from_number = params["From"]

    new_event_keywords = ["N", "NE", "NEW EVENT", "", "START", "+"] #TODO: Make this customizable via config file later
    join_event_keywords = ["J", "JOIN"]

    original_message = message_body.strip
    keyword = (message_body.strip.upcase)[0]

    if new_event_keywords.include? keyword
      # Create a new event
      event = Event.new
      event.owner = from_number
      event.save

      PhoneNumber.send_sms_message_to_number("Your Code is: #{event.code}", from_number)

    elsif join_event_keywords.include? keyword
      tokenized_message = original_message.split
      if tokenized_message.size > 1
        event_code = tokenized_message[1]
        event = Event.where(status: 'ACTIVE', code: event_code).first

        event.add_attendee(from_number) if event.present?
        PhoneNumber.send_sms_message_to_number("You have been added. Thank you.", from_number)
      end
      # Add attendee to event
    else
      event = Event.where(owner: from_number, status: 'ACTIVE').first
      if event.present?
        event.attendees.each do |attendee|
          PhoneNumber.send_sms_message_to_number("Notification: #{original_message}", attendee.phone_number)
        end
        PhoneNumber.send_sms_message_to_number("Notifications sent", from_number)
      end
      # if num is from an event organizer with active event, forward message to everyone on event
    end

    render :text => "Done"

  end
end
