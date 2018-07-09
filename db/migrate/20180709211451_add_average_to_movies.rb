class AddAverageToMovies < ActiveRecord::Migration[5.2]
  def change
    add_column :movies, :average, :integer
  end
end
