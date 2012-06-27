class Team < ActiveRecord::Base
  
  has_many :riders

  after_update :update_rider_team_name

  # Cached team_name
  def update_rider_team_name
    riders.update_all("team_name = '#{name}'")
  end

  def budget
    riders.sum(:price)
  end

end
