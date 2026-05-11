# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # --- Artists ---
    field :artists, [Types::ArtistType], null: false
    def artists
      Artist.all
    end

    field :artist, Types::ArtistType, null: true do
      argument :id, ID, required: true
    end
    def artist(id:)
      Artist.find(id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    # --- Songs ---
    field :songs, [Types::SongType], null: false
    def songs
      Song.all
    end

    field :song, Types::SongType, null: true do
      argument :id, ID, required: true
    end
    def song(id:)
      Song.find(id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

    # --- Playlists ---
    field :playlists, [Types::PlaylistType], null: false
    def playlists
      Playlist.all
    end

    field :playlist, Types::PlaylistType, null: true do
      argument :id, ID, required: true
    end
    def playlist(id:)
      Playlist.find(id)
    rescue ActiveRecord::RecordNotFound
      nil
    end

  end
end