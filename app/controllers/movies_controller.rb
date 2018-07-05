class MoviesController < ApplicationController
  # home page
  def index
    @searchParam = params[:search]

    if @searchParam
      @search = Tmdb::Search.movie(@searchParam).results.select{|e| !e.poster_path.nil?}
    end
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

    # generate names for game and update play count
    @names = generate_names
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
      cast = Tmdb::Movie.cast(params[:id])

      # create a new movie object
      new_movie = Movie.new(
        id: params[:id],
        title: search.title,
        poster_path: search.poster_path,
        cast: cast.select{|e| !e.profile_path.nil?}[0..4],
        playcount: 0
      )

      # save movie to database and return
      new_movie.save
      new_movie
    end

    # generate names for game
    # 3 gamemodes:
    #   0 - actor names only
    #   1 - character names only
    #   2 - a mix of both actor and character names
    def generate_names (gamemode = 0)
      names = []

      # add names to list according to mode
      @movie.cast.each_with_index do |actor, i|
        if gamemode != 1
          names.push({ name: actor.name, idx: i })
        end

        if gamemode != 0
          names.push({ name: actor.character, idx: i })
        end
      end

      # randomize order and return up to 7 names
      names.shuffle[0..6]
    end
end
