module SessionsHelper
	def sign_in(user)
    	cookies[:auth_token] = user.auth_token
    	current_user = user
	end

    def sign_out
        current_user = nil
        cookies.delete(:auth_token)
    end

	def current_user=(user)
    	@current_user = user
 	end

 	def current_user
        @current_user ||= user_from_auth_token
    end

    def current_user?(user)
        user == current_user
    end

    def signed_in_user
        unless signed_in?
            store_location
            redirect_to signin_path, notice: "Please sign in."
        end
    end

	def signed_in?
    	!current_user.nil?
  	end

    def redirect_back_or(default)
        redirect_to(session[:return_to] || default)
        clear_return_to
    end

    def store_location
        session[:return_to] = request.fullpath
    end

private

    def user_from_auth_token
		auth_token = cookies[:auth_token]
		User.find_by_auth_token(auth_token) unless auth_token.nil?
    end

    def clear_return_to
      session.delete(:return_to)
    end
end
