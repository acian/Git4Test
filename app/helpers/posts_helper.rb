module PostsHelper
  
    def belongs_to_user
    if @post.user_id.equal?(current_user.id)
        true
      else
        false
    end
  end
  
  def calculate_rating
     if @post.comments.blank?
      @avg_comments = 0
    else
      @avg_comments = @post.comments.average(:rating).round(2)
    end
    @avg_comments
   end 
  
end
