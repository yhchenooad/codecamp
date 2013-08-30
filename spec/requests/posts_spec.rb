require 'spec_helper'

describe "Posts" do
	let(:user) { create(:user) }

	describe "GET /posts" do
  	it "redirects to sign-in" do
      visit posts_path
  		page.should have_content("Please sign-in")
  	end

    it "indexes" do
      login(user)
      visit posts_path
      page.should have_content("Posts")
      page.should have_content(user.name)
      page.should have_content("0 posts")
    end
  end

  describe "POST /posts" do
		it "posts" do
			post = build(:post, user: user)
			login(user)
			visit posts_path
			fill_in :post_content, with: post.content
			click_button "Post"
			page.should have_content("Posted successfully")
			page.should have_content(post.content)
		end

		it "shows following post" do
			following = create(:following, from: user)
			post = create(:post, user: following.to)
			login(user)
			visit posts_path
			page.should have_content(post.content)
		end

		it "no blank content" do
			login(user)
			visit posts_path
			click_button "Post"
			page.should have_content("Content can't be blank")
		end
	end
end