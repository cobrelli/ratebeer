class PlacesController < ApplicationController
  def show
    #@place = @places[6742]
    #@place = BeermappingApi.places_in(session[:last_city])[params[:id]]
    @place = BeermappingApi.fetch_place(params[:id])
  end

  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    #session[:last_city] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end