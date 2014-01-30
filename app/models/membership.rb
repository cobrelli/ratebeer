class Membership < ActiveRecord::Base
	belongs_to :user
	belongs_to :beer_club

 	#validates_uniqueness_of :user_id, scope: :beer_club_id

	#validates :user_id, :uniqueness => { :scope => :beer_club_id }
	#validates :beer_club_id, :uniqueness => { :scope => :user_id }
	#validates :user_id, uniqueness: true
end
