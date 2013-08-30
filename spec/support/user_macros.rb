module UserMacros
	def login(user)
		visit new_sessions_path
		fill_in :session_email, with: user.email
		fill_in :session_password, with: user.password
		click_button "Sign-in"
	end

	def register(user)
		visit new_user_path
		fill_in :user_name, with: user.name
		fill_in :user_email, with: user.email
		fill_in :user_password, with: user.password
		fill_in :user_password_confirmation, with: user.password_confirmation
		click_button "Register"
	end
end