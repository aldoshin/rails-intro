class MoviesController < ApplicationController
  
  attr_reader :movie_title_class

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @selected_ratings = params[:ratings].respond_to?('keys') ? params[:ratings].keys : params[:ratings]
    
    if @selected_ratings.nil? or params[:sort].nil?
      redirect_to sort: (params[:sort] || session[:sort] || ''),  ratings: (@selected_ratings || session[:ratings] || Movie.get_all_ratings) and return
    end
    
    @all_ratings ||= Movie.get_all_ratings
    @release_date_header_class, @title_header_class = ''

    sort = params[:sort]
    instance_eval %Q"@#{sort}_header_class = 'hilite'" if sort
    
    @movies = Movie.where(rating: @selected_ratings).order(sort)
    
    session[:sort] = sort
    session[:ratings] = params[:ratings]
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
