class RenameExpiredToExpires < ActiveRecord::Migration
  def up
    rename_column :events, :expired, :expires
  end

  def down
  end
end
