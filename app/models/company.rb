class Company < ActiveRecord::Base
  has_many :users
  has_many :profiles, through: :users

  def total_profile_views
    profiles.sum(:views)
  end

  def average_profile_views
    profiles.average(:views)
  end
end
