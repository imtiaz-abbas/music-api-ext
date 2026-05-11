# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_artist,        mutation: Mutations::CreateArtist
    field :update_artist,        mutation: Mutations::UpdateArtist
    field :delete_artist,        mutation: Mutations::DeleteArtist

    field :create_song,          mutation: Mutations::CreateSong
    field :update_song,          mutation: Mutations::UpdateSong
    field :delete_song,          mutation: Mutations::DeleteSong

    field :create_playlist,      mutation: Mutations::CreatePlaylist
    field :update_playlist,      mutation: Mutations::UpdatePlaylist
    field :delete_playlist,      mutation: Mutations::DeletePlaylist

    field :add_song_to_playlist, mutation: Mutations::AddSongToPlaylist
  end
end
