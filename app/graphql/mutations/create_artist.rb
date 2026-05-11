# frozen_string_literal: true

module Mutations
  class CreateArtist < BaseMutation
    argument :name,  String, required: true
    argument :genre, String, required: true

    field :artist, Types::ArtistType, null: true
    field :errors, [String], null: false

    def resolve(name:, genre:)
      artist = Artist.new(name: name, genre: genre)
      if artist.save
        { artist: artist, errors: [] }
      else
        { artist: nil, errors: artist.errors.full_messages }
      end
    end
  end
end
