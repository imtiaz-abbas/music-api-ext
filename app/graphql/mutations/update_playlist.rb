# frozen_string_literal: true

module Mutations
  class UpdatePlaylist < BaseMutation
    argument :id,   ID,     required: true
    argument :name, String, required: false

    field :playlist, Types::PlaylistType, null: true
    field :errors,   [String],            null: false

    def resolve(id:, **attrs)
      playlist = Playlist.find_by(id: id)
      return { playlist: nil, errors: ["Playlist with id #{id} not found"] } unless playlist

      if playlist.update(attrs)
        { playlist: playlist, errors: [] }
      else
        { playlist: nil, errors: playlist.errors.full_messages }
      end
    end
  end
end
