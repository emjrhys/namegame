class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies, id: false do |t|
      t.integer :id
      t.string :title
      t.string :poster
      t.text :cast
      t.integer :playcount

      t.timestamps
    end
  end
end
