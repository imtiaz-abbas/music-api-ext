# frozen_string_literal: true

module Types
  class ArtistType < Types::BaseObject
    field :id,    ID,     null: false
    field :name,  String, null: false
    field :genre, String, null: false

    field :songs, [Types::SongType], null: false
  end
end