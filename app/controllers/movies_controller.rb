class MoviesController < ApplicationController

  def index
    # these two are so that the selected option/typed query will persist
    @query = params[:q]
    @duration = params[:duration]

    if !params[:q] && !params[:duration]
      @movies = Movie.all
    else
      @movies = Movie
      if params[:q] && params[:q].length > 0
        q = "%#{params[:q].downcase}%"
        @movies = @movies.where("lower(title) like ? or lower(director) like ?", q, q)
      end

      case params[:duration]
      when "1"
        @movies = @movies.where("runtime_in_minutes <= 90")
      when "2"
        @movies = @movies.where("runtime_in_minutes > 90 and runtime_in_minutes <= 120")
      when "3"
        @movies = @movies.where("runtime_in_minutes > 120")
      else
        @movies = @movies.where("runtime_in_minutes > 0")
      end
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
