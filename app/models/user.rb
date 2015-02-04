class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  before_validation :make_first_user_admin!
         
  has_attached_file :avatar, :styles => { :medium => "300x300>"}, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  
  def make_first_user_admin!
    if User.count == 0
    self.admin = true
    end
  end

end
