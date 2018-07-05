module MoviesHelper
  def random_movie
    Movie.order("RANDOM()").limit(1)[0]
  end
end
