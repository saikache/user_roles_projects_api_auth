class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/
  before_validation :check_password

  has_many :user_roles
  has_many :roles, :through => :user_roles
  has_many :permissions, :through => :roles
  has_and_belongs_to_many :projects

  def authenticate(plaintext_password)
    if BCrypt::Password.new(self.password_digest) == plaintext_password
      self
    else
      false
    end
  end

  # Define multiple method for different models (project, and can manage other models etc.)
  [:can_new, :can_edit, :can_delete].each do |method_name, model|
    define_method method_name do |model|
      permission = self.permissions.find_by(permission_type: model)
      permission.send(method_name) rescue false
    end
  end

  private

  # SecureRand.hex(2) can set a random password also
  def check_password
    self.password = '1234' unless password
  end

end
