require 'spec_helper'
include OwnTestHelper

describe "beers page" do
	it "should not have any before been created" do
    	visit beers_path

    	expect(page).to have_content 'Listing beers'
    	expect(page).to have_content 'Number of beers: 0'
	end

	describe "when beers exists" do

		before :each do
			FactoryGirl.create(:brewery)
			FactoryGirl.create(:user)
    		sign_in username:"Pekka", password:"Foobar1"
		end

		it "should let add new beer with valid name" do
			visit new_beer_path

			fill_in('beer_name', with:'anomuumi')
			
			expect{
      			click_button('Create Beer')
    		}.to change{Beer.count}.by(1)
		end

		it "should NOT let add new beer with invalid name" do
			visit new_beer_path

			click_button('Create Beer')

			expect(page).to have_content "New beer"
			expect(page).to have_content "Name can't be blank"
			expect(Beer.count).to eq(0)
		end
	end
end