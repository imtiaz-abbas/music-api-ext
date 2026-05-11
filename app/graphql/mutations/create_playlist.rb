# frozen_string_literal: true

module Mutations
  class CreatePlaylist < BaseMutation
    argument :name, String, required: true

    field :playlist, Types::PlaylistType, null: true
    field :errors,   [String],            null: false

    def resolve(name:)
      playlist = Playlist.new(name: name)
      if playlist.save
        { playlist: playlist, errors: [] }
      else
        { playlist: nil, errors: playlist.errors.full_messages }
      end
    end
  end
end
