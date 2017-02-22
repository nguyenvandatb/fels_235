class AddDefaultToLessons < ActiveRecord::Migration
  def up
    change_column_default :lessons, :is_finished, false
  end

  def down
    change_column_default :lessons, :is_finished, nil
  end
end
