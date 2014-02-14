require 'spec_helper'

include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "favorite beer style is shown correctly" do
    #FactoryGirl.create(:style, name:"Lager")
    beer1 = FactoryGirl.create(:beer)
    beer2 = FactoryGirl.create(:beer2)
    FactoryGirl.create(:rating, user:User.first, beer:beer1, score:50)
    FactoryGirl.create(:rating, user:User.first, beer:beer2, score:2)

    visit user_path(User.first)

    expect(page).to have_content("favourite beer style: testi")
  end

  it "favorite brewery is shown correctly" do
    brewery = FactoryGirl.create(:brewery, name:"Supermesta")
    beer1 = FactoryGirl.create(:beer)
    beer2 = FactoryGirl.create(:beer, brewery:brewery, name:"Best")
    beer3 = FactoryGirl.create(:beer, brewery:brewery, name:"Best2")
    FactoryGirl.create(:rating, user:User.first, beer:beer1)
    FactoryGirl.create(:rating, user:User.first, beer:beer2, score:50)
    FactoryGirl.create(:rating, user:User.first, beer:beer3, score:50)

    visit user_path(User.first)

    expect(page).to have_content("favourite brewery: Supermesta")
  end
end

BeerClub
BeerClubsController