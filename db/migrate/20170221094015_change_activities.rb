class ChangeActivities < ActiveRecord::Migration[5.0]
  def change
    change_column :activities, :action_type, :integer
  end
end
