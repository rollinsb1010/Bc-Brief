class AddPriorityToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :priority, :integer
  end

  def self.down
    remove_column :projects, :priority
  end
end
