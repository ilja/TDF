class TeamsController < ApplicationController

  load_and_authorize_resource

  def index
    @teams = TeamDecorator.decorate(@teams)
  end

  def show
    @team = TeamDecorator.decorate(@team)
    @riders = RiderDecorator.decorate(@team.riders.order(riders_sort_order))
  end

end
