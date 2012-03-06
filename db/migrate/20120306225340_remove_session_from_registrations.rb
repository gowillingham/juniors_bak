class RemoveSessionFromRegistrations < ActiveRecord::Migration
  def self.up
    remove_column :registrations, :session
  end

  def self.down
    add_column :registrations, :session, :integer
  end
end
