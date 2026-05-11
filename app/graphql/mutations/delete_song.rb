# frozen_string_literal: true

module Mutations
  class DeleteSong < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors,  [String], null: false

    def resolve(id:)
      song = Song.find_by(id: id)
      return { success: false, errors: ["Song with id #{id} not found"] } unless song

      song.destroy
      { success: true, errors: [] }
    end
  end
end
