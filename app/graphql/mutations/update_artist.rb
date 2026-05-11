# frozen_string_literal: true

module Mutations
  class UpdateArtist < BaseMutation
    argument :id,    ID,     required: true
    argument :name,  String, required: false
    argument :genre, String, required: false

    field :artist, Types::ArtistType, null: true
    field :errors, [ String ],          null: false

    def resolve(id:, **attrs)
      artist = Artist.find_by(id: id)
      return { artist: nil, errors: [ "Artist with id #{id} not found" ] } unless artist

      if artist.update(attrs)
        { artist: artist, errors: [] }
      else
        { artist: nil, errors: artist.errors.full_messages }
      end
    end
  end
end
