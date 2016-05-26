class MoviesController < ApplicationController

  def index
    # these two are so that the selected option/typed query will persist
    @query = params[:q]
    @duration = params[:duration]

    if params[:q] || params[:duration]
      @movies = Movie.contains_text(params[:q])

      case params[:duration]
      when "1"
        @movies = @movies.merge(Movie.less_than_90_minutes)
      when "2"
        @movies = @movies.merge(Movie.between_90_and_120_minutes)
      when "3"
        @movies = @movies.merge(Movie.more_than_120_minutes)
      end
    else
      @movies = Movie.all
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
   @movie = Movie.find(params[:id])

   if @movie.update_attributes(movie_params)
     redirect_to movie_path(@movie)
   else
     render :edit
   end
  end

  def destroy
   @movie = Movie.find(params[:id])
   @movie.destroy
   redirect_to movies_path
  end

  protected

  def movie_params
   params.require(:movie).permit(
     :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :description
   )
  end

end
