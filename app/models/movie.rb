class Movie < ActiveRecord::Base

RATINGS = ['G','PG','PG-13','R','NC-17']
attr_accessible :title, :rating, :description, :release_date
  
  def Movie.get_all_ratings
      RATINGS
  end
end
