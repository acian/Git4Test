class CommentsController < ApplicationController
  
   load_and_authorize_resource :nested => :post  
   
   before_action :set_post
   before_filter :check_comment, :only => [:new]
   before_action :authenticate_user!
   
  def new
    @comment = Comment.new
  end
  
   def create 
   @comment = @post.comments.new(comment_params)
   @comment.user_id = current_user.id
           
     if @comment.save
      redirect_to post_path(@post)
    else
      render 'new'
    end
    
  end
  
  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
 
    redirect_to post_path(@post)
  end
  
  private
  
  def comment_params
      params.require(:comment).permit(:body, :rating)
    end
  
   def set_post
      @post = Post.find(params[:post_id])
    end
    
    def check_comment
    @comments = Comment.where('user_id' => current_user.id, 'post_id' => params[:post_id] )
    if !@comments.blank?
        redirect_to post_path(@post), :alert => 'You have already voted thank you very much!'
      return false
    end
  
  end 
    
end
