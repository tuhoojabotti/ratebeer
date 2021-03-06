class BeersController < ApplicationController
  before_action :set_beer, only: [:show, :edit, :update, :destroy]
  before_action :set_breweries_and_styles, only: [:new, :edit]
  before_action :ensure_that_signed_in, except: [:index, :show, :list, :nglist]
  before_action :ensure_that_is_admin, only: [:destroy]
  before_action :skip_if_cached, only:[:index]

  def skip_if_cached
    @order = params[:order] || 'name'
    return render :index if fragment_exist?( "beerlist-#{params[:order]}"  )
  end

  # GET /beers
  # GET /beers.json
  def index
    case params[:order]
      when 'brewery' then
        @beers = Beer.includes(:brewery, :style).order("breweries.name")
      when 'style' then
        @beers = Beer.includes(:brewery, :style).order("styles.name")
      else
        @beers = Beer.includes(:brewery, :style).order(:name)
    end
  end

  def list
  end

  def nglist
  end  

  # GET /beers/1
  # GET /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer    
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    ["name", "brewery", "style"].each{ |f| expire_fragment("beerlist-" + f) }
  end

  # GET /beers/1/edit
  def edit
    ["name", "brewery", "style"].each{ |f| expire_fragment("beerlist-" + f) }
  end

  # POST /beers
  # POST /beers.json
  def create
    ["name", "brewery", "style"].each{ |f| expire_fragment("beerlist-" + f) }
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_url, notice: 'Beer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @beer }
      else
        set_breweries_and_styles
        format.html { render action: 'new' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1
  # PATCH/PUT /beers/1.json
  def update
    ["name", "brewery", "style"].each{ |f| expire_fragment("beerlist-" + f) }
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: 'Beer was successfully updated.' }
        format.json { head :no_content }
      else
        set_breweries_and_styles
        format.html { render action: 'edit' }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1
  # DELETE /beers/1.json
  def destroy
    ["name", "brewery", "style"].each{ |f| expire_fragment("beerlist-" + f) }
    @beer.destroy
    respond_to do |format|
      format.html { redirect_to beers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beer
      @beer = Beer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beer_params
      params.require(:beer).permit(:name, :brewery_id, :style_id)
    end

    def set_breweries_and_styles
      @breweries = Brewery.all
      @styles = Style.all
    end
end
