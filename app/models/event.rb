class Event < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :attendees
  after_initialize :set_defaults

  def set_defaults
    self.code = self.generate_tron_code
    self.status = 'ACTIVE'
    self.expires = DateTime.now + 1.day
  end

  def generate_tron_code
    Random.rand(10000)
  end
end
