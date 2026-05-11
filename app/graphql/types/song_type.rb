# frozen_string_literal: true

module Types
  class SongType < Types::BaseObject
    field :id,        ID,      null: false
    field :title,     String,  null: false
    field :duration,  Integer, null: false
    field :artist_id, ID,      null: false

    field :artist, Types::ArtistType, null: false
  end
end