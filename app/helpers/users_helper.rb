# frozen_string_literal: true

module UsersHelper
  def confirm_admin
    return if current_user&.admin?

    redirect_to root_path
  end
end
