# frozen_string_literal: true
module Welcome
  class NamesController < ApplicationController
    def edit
      @user = current_user
    end

    def update
      @user = current_user
      @user.attributes = user_params
      @user.allow_nil_email = true

      if @user.save(context: :edit_first_name)
        redirect_to edit_welcome_account_path
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(:first_name)
    end
  end
end
