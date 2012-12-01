class Attendee < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :event

  before_create :set_defaults

  def set_defaults
    self.status = 'ACTIVE'
  end


end
