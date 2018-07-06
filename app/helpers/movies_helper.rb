module MoviesHelper
  def random_movie
    Movie.order("RANDOM()").limit(1)[0]
  end

  def poster_url poster_path
    'https://image.tmdb.org/t/p/w500' + poster_path
  end

  def movie_url id
    'https://www.themoviedb.org/movie/' + id.to_s
  end
end
