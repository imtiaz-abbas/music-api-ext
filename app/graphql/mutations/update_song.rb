# frozen_string_literal: true

module Mutations
  class UpdateSong < BaseMutation
    argument :id,        ID,      required: true
    argument :title,     String,  required: false
    argument :duration,  Integer, required: false
    argument :artist_id, ID,      required: false

    field :song,   Types::SongType, null: true
    field :errors, [ String ],        null: false

    def resolve(id:, **attrs)
      song = Song.find_by(id: id)
      return { song: nil, errors: [ "Song with id #{id} not found" ] } unless song

      if song.update(attrs)
        { song: song, errors: [] }
      else
        { song: nil, errors: song.errors.full_messages }
      end
    end
  end
end
