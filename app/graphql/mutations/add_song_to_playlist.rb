# frozen_string_literal: true

module Mutations
  class AddSongToPlaylist < BaseMutation
    argument :playlist_id, ID, required: true
    argument :song_id,     ID, required: true

    field :playlist, Types::PlaylistType, null: true
    field :errors,   [ String ],            null: false

    def resolve(playlist_id:, song_id:)
      playlist = Playlist.find_by(id: playlist_id)
      song     = Song.find_by(id: song_id)

      unless playlist
        return { playlist: nil, errors: [ "Playlist with id #{playlist_id} not found" ] }
      end
      unless song
        return { playlist: nil, errors: [ "Song with id #{song_id} not found" ] }
      end

      playlist_song = PlaylistSong.new(playlist: playlist, song: song)
      if playlist_song.save
        { playlist: playlist.reload, errors: [] }
      else
        { playlist: nil, errors: playlist_song.errors.full_messages }
      end
    end
  end
end
