class Event < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :owner
      t.string :code
      t.datetime :expired
      t.timestamps
    end
  end

  def down
  end
end
