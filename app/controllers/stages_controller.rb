class StagesController < ApplicationController

  def index
    @stages = StageDecorator.decorate(Stage.order(:number))
  end

  def show
    @stage = StageDecorator.decorate(Stage.find(params[:id]))
    @sorted_players = sort_players_by_stage_points(PlayerDecorator.decorate(Player.active), @stage)
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

  private

  def sort_players_by_stage_points(players, stage)
    players.collect{ |p| [p.stage_points(stage), p] }.sort_by{ |sp| sp[0] }.reverse
  end

end
