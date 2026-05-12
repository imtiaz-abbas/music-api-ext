class AddUniqueIndexToPlaylistSongs < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :playlist_songs, [ :playlist_id, :song_id ],
              unique: true,
              algorithm: :concurrently,
              name: "index_playlist_songs_unique"
  end
end
