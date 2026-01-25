class AddTracklistsTracksJoinTable < ActiveRecord::Migration[8.1]
  def change
    create_table :tracklists_tracks, id: :uuid do |t|
      t.references :tracklist, type: :uuid, foreign_key: true
      t.references :track, type: :uuid, foreign_key: true

      t.integer :track_number, null: false

      t.timestamps
    end
  end
end
