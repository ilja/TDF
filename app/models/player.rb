class Player < ActiveRecord::Base

  BUDGET = 100
  MAX_RIDERS = 10

  has_many :player_riders
  has_many :riders, :through => :player_riders
  has_many :scores, :through => :riders

  validates :name, :team_name, :presence => true, :uniqueness => true

  def stage_points(stage)
    riders.joins(:scores).where("scores.stage_id" => stage.id).sum("scores.points")
  end

  def budget
    BUDGET - expenses
  end

  def expenses
    riders.sum(:price)
  end

  def riders_to_pick
    MAX_RIDERS - riders.count
  end

  def can_pick_riders?
    MAX_RIDERS > riders.count
  end

  def available_riders
    return [] unless can_pick_riders?
    _riders = Rider.where(["price < ?", budget])
    if riders.count > 0
      _riders = _riders.where(["riders.id NOT IN (?)", rider_ids])
    end
    _riders
  end

  def team_ready?
    MAX_RIDERS == riders.count && budget >= 0
  end

end
