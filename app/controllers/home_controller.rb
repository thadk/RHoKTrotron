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

  end
end
