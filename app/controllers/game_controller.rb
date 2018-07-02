class GameController < ApplicationController
  def index
  end

  def play
    @id = params[:movieid]
    @cast = Tmdb::Movie.cast(@id)
  end
end
