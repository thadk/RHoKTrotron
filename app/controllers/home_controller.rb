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

    keyword = (message_body.strip.upcase)[0]

    if new_event_keywords.include? keyword
      # Create a new event
      event = Event.new
      event.owner = from_number
      event.save

      PhoneNumber.send_sms_message_to_number(event.code, from_number)

    elsif join_event_keywords.include? keyword
      # Add attendee to event
    else
      # if num is from an event organizer with active event, forward message to everyone on event
    end

    render :text => "Done"

  end
end
