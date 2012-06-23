# encoding: utf-8
class RiderDecorator < Draper::Base
  decorates :rider

  def name
    model.first_name.to_s + ' ' + model.last_name.to_s
  end

  def price
    h.number_to_euro(model.price * 100000)
  end

  def role
    model.ad_role
  end

  def team_name(view_mode = :normal, options = {})
    if view_mode.to_sym == :truncate
      h.truncate(model.team_name, :length => (options.delete(:length) || 20))
    else
      model.team_name
    end
  end

end
