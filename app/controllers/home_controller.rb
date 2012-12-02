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

    new_event_keywords = ["N", "NE", "NEW", "", "+"] #TODO: Make this customizable via config file later
    end_event_keywords = ["CLOSE", "DONE", "X", "C"]
    join_event_keywords = ["J", "JOIN"]
    stop_keywords = ["BYE", "XX"]

    original_message = message_body.strip
    tokenized_message = original_message.split
    keyword = (message_body.strip.upcase).split[0]

    puts "HERE: #{stop_keywords.inspect} -- #{keyword}"

    if new_event_keywords.include? keyword
      event = Event.new
      event.owner = from_number
      event.save

      PhoneNumber.send_sms_message_to_number("Your Code is: #{event.code}", from_number)

    elsif stop_keywords.include? keyword
      #Lazy way to do it, opt attendee out of everything
      Attendee.where(phone_number: from_number, status: 'ACTIVE').each do |a|
        a.status = 'INACTIVE';
        a.save
      end
      PhoneNumber.send_sms_message_to_number("Notifications turned off. Thank you.", from_number)

    elsif join_event_keywords.include? keyword
      if tokenized_message.size > 1
        event_code = tokenized_message[1]
        event = Event.where(status: 'ACTIVE', code: event_code).first   #TODO: should also take expiry into consideration

        if event.present?
          event.add_attendee(from_number)
          PhoneNumber.send_sms_message_to_number("You have been added. Thank you.", from_number)
        end
      end
    else
      event = Event.where(owner: from_number, status: 'ACTIVE').first
      if event.present?
        if end_event_keywords.include? keyword
          event.status = 'INACTIVE'
          event.attendees.each{|a| a.status = 'INACTIVE'; a.save}
          event.save
          PhoneNumber.send_sms_message_to_number("Close successful. Thank you.", from_number)
        else
          puts "Did it get here? 1"
          puts "#{event.inspect}"
          puts "#{event.attendees.inspect}"
          event.attendees.select{|attendee| attendee.status == 'ACTIVE' }.each do |attendee|
            puts "Did it get here? 3"
            PhoneNumber.send_sms_message_to_number("Notification: #{original_message} \n (Reply \"BYE\" to stop receiving)", attendee.phone_number)
          end
          PhoneNumber.send_sms_message_to_number("Notifications sent", from_number)
        end
      end
    end

    render :text => "Done"

  end
end
