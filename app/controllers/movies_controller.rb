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
      @movie = create_movie
    end

    # update play count
    @movie.update(playcount: @movie.playcount + 1)
  end

  # delete movies (not in use)
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    redirect_to root_path
  end

  private
    # load movie from api and save to database
    def create_movie
      # make moviedb api calls
      search = Tmdb::Movie.detail(params[:id])
      # get first five cast members with profile picture
      cast = Tmdb::Movie.cast(params[:id]).select{|e| !e.profile_path.nil?}[0..4]
      p cast
      # create a new movie object
      new_movie = Movie.new(
        id: params[:id],
        title: search.title,
        poster_path: search.poster_path,
        cast: cast,
        playcount: 0
      )

      # save movie to database and return
      new_movie.save
      new_movie
    end

    # generate random posters for the home screen
    def generate_marquee_posters count
      movies = Movie.all.shuffle[0..(count/2 - 1)]
      actor_posters = movies.map { |m| m.cast.shuffle[0].profile_path }
      movie_posters = movies.map { |m| m.poster_path }

      (movie_posters + actor_posters).shuffle
    end
end
