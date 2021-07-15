class HomesController < ApplicationController

  def top
    @photos = Photo.limit(8).order('id DESC')
    @photographers = Photographer.where(public_status: true).limit(4).order('id DESC')
  end

end
