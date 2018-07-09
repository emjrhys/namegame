class Movie < ApplicationRecord
  validates :title, :id, :cast, presence: true
  serialize :cast
  self.primary_key = :id

  # load movie details from api and save to database
  def self.create_from_tmdb tmdbid
    # make moviedb api calls
    search = Tmdb::Movie.detail(tmdbid)
    # get first five cast members with profile picture
    cast = Tmdb::Movie.cast(tmdbid).select{|e| !e.profile_path.nil?}[0..4]
    # create a new movie object
    new_movie = Movie.new(
      id: tmdbid,
      title: search.title,
      poster_path: search.poster_path,
      cast: cast,
      playcount: 0
    )

    # save movie to database and return
    new_movie.save
    new_movie
  end
end
