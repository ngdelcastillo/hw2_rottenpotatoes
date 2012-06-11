class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    #set the ratings based on params or session
    @ratings = params[:ratings] == nil && params[:commit] == nil && params[:sort] == nil ? session[:ratings] : params[:ratings]
    
    #clear session if the refresh
    unless params[:commit] == nil
      session.clear if params[:commit] == "Refresh"
    end

    #specify the params to be added in the url
    @ratings_param = ""
    unless @ratings == nil
      @ratings.keys.each do |rating|
        @ratings_param += "&ratings%5B" + rating.to_s + "%5D=1"
      end
      #set ratings in session
      session[:ratings] = @ratings
    end

    #set the sort based on params or session
    @sort_by = params[:sort] == nil && params[:commit] == nil ? session[:sort] : params[:sort]
    unless @sort_by == nil
      #set to session
      session[:sort] = @sort_by
    end

    #provide movies based on ratings and sort
    @movies = Movie.filter_rating(@ratings).order(@sort_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
