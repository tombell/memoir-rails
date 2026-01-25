class AddTracksTable < ActiveRecord::Migration[8.1]
  def change
    create_table :tracks, id: :uuid do |t|
      t.string :artist, null: false
      t.string :name, null: false
      t.string :genre, null: false
      t.float :bpm, null: false
      t.string :key, null: false

      t.timestamps
    end
  end
end
