class Attendee < ActiveRecord::Migration
  def up
    create_table :attendee do |t|
      t.integer :event_id
      t.string :phone_number
    end
  end

  def down
  end
end
