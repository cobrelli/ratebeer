class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :password, :format => {:with => /(?=.*\d)(?=.*[A-Z])(?=.*[a-zA-Z]).{4,}/ }

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 15 }

  has_many :ratings  
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships

end