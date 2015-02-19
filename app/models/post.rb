class Post < ActiveRecord::Base
  searchkick
  has_many :comments, dependent: :destroy
  
  has_attached_file :image, :styles => { :medium => "300x300>"}, :default_url => "/images/:style/missing.png"
    
  validates_attachment :image, :presence => true,
  :content_type => { :content_type => ["image/jpeg", "image/png"] },
  :size => { :in => 1..2.megabyte }
  
  validates :title, presence: true, length: {minimum: 5}
  validates :body, presence: true
    
end