class GenresController < ApplicationController

  def index
    genre = Genre.find(params[:id])
    @photos = genre.photos.sort.reverse
    @photographers = genre.photographers
    render 'searches/index'
  end

end
