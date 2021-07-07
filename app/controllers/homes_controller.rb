class HomesController < ApplicationController

  def top
    @photos = Photo.limit(8).order('id DESC')
    @photographers = Photographer.limit(4).order('id')
  end

end
