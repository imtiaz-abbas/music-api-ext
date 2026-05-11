# frozen_string_literal: true

module Mutations
  class DeleteArtist < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors,  [ String ], null: false

    def resolve(id:)
      artist = Artist.find_by(id: id)
      return { success: false, errors: [ "Artist with id #{id} not found" ] } unless artist

      artist.destroy
      { success: true, errors: [] }
    end
  end
end
