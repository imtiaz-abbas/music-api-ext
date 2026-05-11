# frozen_string_literal: true

module Mutations
  class DeletePlaylist < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false
    field :errors,  [ String ], null: false

    def resolve(id:)
      playlist = Playlist.find_by(id: id)
      return { success: false, errors: [ "Playlist with id #{id} not found" ] } unless playlist

      playlist.destroy
      { success: true, errors: [] }
    end
  end
end
