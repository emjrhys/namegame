class ChangeAverageToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :movies, :average, :float
  end
end
