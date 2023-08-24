class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # effective_pages_organization_user
  # effective_pages_user

  def to_s
    "#{first_name} #{last_name}"
  end

end
