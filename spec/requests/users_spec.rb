require 'spec_helper'

describe "Users" do
	let(:user) { create(:user) }
	let(:minions) { create_list(:user, 10) }

	describe "POST /users" do
		it "registers" do
			new_user = build(:user)
			visit new_user_path
			fill_in :user_name, with: new_user.name
			fill_in :user_email, with: new_user.email
			fill_in :user_password, with: new_user.password
			fill_in :user_password_confirmation, with: new_user.password
			click_button "Register"
			page.should have_content("Welcome, #{new_user.name}!")
		end

		it "no blank name" do
			new_user = build(:user)
			visit new_user_path
			fill_in :user_email, with: new_user.email
			fill_in :user_password, with: new_user.password
			fill_in :user_password_confirmation, with: new_user.password
			click_button "Register"
			page.should have_content("Name can't be blank")
		end

		it "no duplicate email" do
			new_user = build(:user)
			visit new_user_path
			fill_in :user_name, with: new_user.name
			# Fill in everything correctly except use an existing email
			fill_in :user_email, with: user.email
			fill_in :user_password, with: new_user.password
			fill_in :user_password_confirmation, with: new_user.password
			click_button "Register"
			page.should have_content("Email has already been taken")
		end

		it "correct email format" do
			new_user = build(:user)
			visit new_user_path
			fill_in :user_name, with: new_user.name
			# Fill in everything correctly except use a bad email
			fill_in :user_email, with: "bad_email_address"
			fill_in :user_password, with: new_user.password
			fill_in :user_password_confirmation, with: new_user.password
			click_button "Register"
			page.should have_content("Email is invalid")
		end

		it "password must match" do
			new_user = build(:user)
			visit new_user_path
			fill_in :user_name, with: new_user.name
			fill_in :user_email, with: new_user.email
			fill_in :user_password, with: new_user.password
			fill_in :user_password_confirmation, with: "something_else"
			click_button "Register"
			page.should have_content("doesn't match")
		end
	end

	describe "GET /users/1" do
  	it "redirects to sign-in" do
  		visit user_path(user)
  		page.should have_content("Please sign-in")
  	end

  	it "shows" do
  		login(user)
  		visit user_path(user)
  		page.should have_content(user.name)
  	end
	end

  describe "PUT /users/1" do
  	# Write specs for updating users
  end

  describe "GET /users" do
  	it "redirects to sign-in" do
      visit users_path
  		page.should have_content("Please sign-in")
  	end

    it "indexes" do
      login(user)
      visit users_path
      page.should have_content("Users")
    end

    it "searches names" do
    	waldos = create_list(:user, 5, name: "waldo #{rand(100000)}")
    	wallys = create_list(:user, 10, name: "wally #{rand(100000)}")
    	login(user)
    	visit users_path
    	fill_in :search, with: "waldo"
    	click_button "Search User"
    	page.should have_content("waldo")
    	page.should_not have_content("wally")
    end
  end

  describe "GET /users/1/followers" do
  	it "redirects to sign-in" do
  		visit followers_user_path(user)
  		page.should have_content("Please sign-in")
  	end

  	it "lists" do
  		followings = create_list(:following, 5, to: user)
  		login(user)
  		visit followers_user_path(user)
  		followings.each { |f| page.should have_content(f.from.name) }
  	end
  end

  describe "POST /users/1/follow", js: true do
  	it "follows" do
  		someone = minions.first
  		login(user)
  		visit users_path
  		link = find(:css, "li.user[user_id='#{someone.id}'] a.btn")
  		link.should have_content("Follow")
  		link.click
  		link.should have_content("Unfollow")
	  end
  end

  describe "DELETE /users/1/unfollow", js: true do
  	it "unfollows" do
  		following = create(:following, from: user)
  		someone = following.to
  		login(user)
  		visit users_path
  		link = find(:css, "li.user[user_id='#{someone.id}'] a.btn")
  		link.should have_content("Unfollow")
  		link.click
  		link.should have_content("Follow")
	  end
  end

  describe "GET /users/1/followings" do
  	it "redirects to sign-in" do
  		visit followings_user_path(user)
  		page.should have_content("Please sign-in")
  	end

  	it "lists" do
  		followings = create_list(:following, 5, from: user)
  		login(user)
  		visit followings_user_path(user)
  		followings.each { |f| page.should have_content(f.from.name) }
  	end
  end
end
