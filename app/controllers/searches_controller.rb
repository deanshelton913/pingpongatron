class SearchesController < ApplicationController

  def players
    search do
      params[:q].downcase!
      Player.where("name LIKE :prefix", prefix: "#{params[:q]}%")
    end
  end
  private

  def search(&block)    
    if params[:q]
      @results = yield if block_given?
      respond_to do |format|
        format.any { render json: @results.to_json(methods: :thumbnail)  }
      end
    else
      redirect_to root_url, :notice => 'No search query was specified.'
    end
  end

end