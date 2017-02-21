class AddCountToLessons < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :correct_count, :integer
  end
end
