class StagesController < ApplicationController

  def index
    @stages = StageDecorator.decorate_collection(Stage.order(:number))
  end

  def show
    @stages = StageDecorator.decorate_collection(Stage.order(:number))
    @stage = StageDecorator.decorate(Stage.find(params[:id]))

    @sorted_players = sort_players_by_stage_points(PlayerDecorator.decorate_collection(Player.active), @stage)
    @sorted_riders = sort_riders_by_stage_points(RiderDecorator.decorate_collection(Rider.active), @stage)
    @player = PlayerDecorator.decorate(Player.find_by_id(params[:player_id]) || current_player || @sorted_players.first)
  end

  def edit
    @stage = Stage.find(params[:id])
  end

  def update
    @stage = Stage.find(params[:id])
    if @stage.update_attributes(params[:stage])
      redirect_to stage_path(@stage), :notice => "Etappe aangepast"
    else
      render :action => "edit"
    end
  end

  def player_points
    @stages = Stage.all
    @players = Player.all
  end


end
