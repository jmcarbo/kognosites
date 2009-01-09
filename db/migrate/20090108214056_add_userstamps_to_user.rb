class AddUserstampsToUser < ActiveRecord::Migration
  def self.up
		add_column :users, :creator_id, :integer
		add_column :users, :updater_id, :integer
		add_column :users, :deleter_id, :integer
  end

  def self.down
		remove_column :users, :creator_id
		remove_column :users, :updater_id
		remove_column :users, :deleter_id

  end
end
