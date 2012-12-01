class AddStatusToAttendee < ActiveRecord::Migration
  def change
    rename_table :attendee, :attendees
    add_column :attendees, :status, :string
  end
end
