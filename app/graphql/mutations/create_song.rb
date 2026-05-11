# frozen_string_literal: true

module Mutations
  class CreateSong < BaseMutation
    argument :title,     String,  required: true
    argument :duration,  Integer, required: true
    argument :artist_id, ID,      required: true

    field :song,   Types::SongType, null: true
    field :errors, [ String ],        null: false

    def resolve(title:, duration:, artist_id:)
      song = Song.new(title: title, duration: duration, artist_id: artist_id)
      if song.save
        { song: song, errors: [] }
      else
        { song: nil, errors: song.errors.full_messages }
      end
    end
  end
end
