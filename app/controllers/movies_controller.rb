class MoviesController < ApplicationController
  # home page
  def index
    @searchParam = params[:search]

    if @searchParam
      @search = Tmdb::Search.movie(@searchParam).results.select{|e| !e.poster_path.nil?}
    end

    @marqueeTop = generate_marquee_posters 20
    @marqueeBottom = generate_marquee_posters 20
  end

  # load movie by id and play the game
  def show
    # check if movie is already saved to db, otherwise load from moviedb api
    if Movie.exists?(params[:id])
      p 'exists'
      @movie = Movie.find(params[:id])
    else
      p 'doesn\'t exists'
      @movie = Movie.create_from_tmdb params[:id]
    end
  end

  # calculate new average when movie is played
  def update
    score = params[:score]
    movie = Movie.find(params[:id])
    average = movie.average
    playcount = movie.playcount

    # if this is the first time, no need to calculate average
    # (also reset playcount to clear old data)
    if average.nil?
      movie.update(playcount: 1, average: score)
    else
      average = ((average * playcount) + score) / (playcount + 1.0)
      movie.update(playcount: playcount + 1, average: average)
    end
  end

  # delete movies (not in use)
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    redirect_to root_path
  end

  private
    # generate random posters for the home screen
    def generate_marquee_posters count
      movies = Movie.all.shuffle[0..(count/2 - 1)]
      actor_posters = movies.map { |m| m.cast.shuffle[0].profile_path }
      movie_posters = movies.map { |m| m.poster_path }

      (movie_posters + actor_posters).shuffle
    end
end
