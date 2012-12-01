class Event < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :attendees
  before_create :set_defaults

  def set_defaults
    self.code = self.generate_tron_code
    self.status = 'ACTIVE'
    self.expires = DateTime.now + 1.day
  end

  def add_attendee(phone_number)
    attendee = Attendee.new
    attendee.phone_number = phone_number
    attendee.event = self
    attendee.save
  end

  def generate_tron_code
    Random.rand(10000)     #TODO: Make sure this is unique and not in use by an active event
  end
end
