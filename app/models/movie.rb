class Movie < ActiveRecord::Base
  def self.filter_rating(ratings)
    ratings == nil ? self : self.where(:rating => ratings.keys)
  end
end
