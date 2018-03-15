class User < ApplicationRecord
  has_secure_password
  validates :email, uniqueness: { case_sensitive: false }
  validate :validateEmail
  validates :phone, numericality: {only_integer: true, minimum: 0, maximum: 9999999999999}
  validates :age, numericality: {only_integer: true, minimum: 0, maximum: 200}
  def validateEmail
    email_check = email.include?("@") && email.split("@")[1].include?(".")
    if email_check == false
      errors.add(:email, 'Invalid email address')
    end
    email_check
  end
end