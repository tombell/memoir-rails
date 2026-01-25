class AddTracklistsTable < ActiveRecord::Migration[8.1]
  def change
    create_table :tracklists, id: :uuid do |t|
      t.string :name, null: false
      t.date :date, null: false
      t.string :artwork, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
