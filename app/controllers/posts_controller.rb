class PostsController < ApplicationController
  
 load_and_authorize_resource only: [:destroy]
 skip_load_resource only: [:create]
 before_filter :find_post, :only => [:show, :edit, :update, :destroy] 
 

  def index
    
 @posts = Post.select('posts.*, 
            (select avg(rating) from comments 
            where post_id = posts.id) as avg')
            .group("posts.id")
            .order("avg DESC")     
            .paginate(:page => params[:page], :per_page => 15)
  end
  
  def my_posts
    
 @posts = Post.select('posts.*, 
            (select avg(rating) from comments 
            where post_id = posts.id) as avg')
            .where('user_id' => current_user.id)
            .group("posts.id")
            .order("avg DESC")     
            .paginate(:page => params[:page], :per_page => 15)
  end
  
 def new
  @post = Post.new
 end

def search
 if params[:search].present?
  @posts = Post.search(params[:search])  
 else
  @posts = Post.all
 end
end
 
def create
  @post = Post.new(post_params)
  @post.user_id = current_user.id
 
  if @post.save
    redirect_to @post
  else
    render 'new'
  end
 end
 
  def show    
  
  end
  
  def edit

  end
 
  def update
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end
  
   def destroy
    @post.destroy
     redirect_to posts_path
  end
    
  private
 
  def post_params
    params.require(:post).permit(:title, :body, :image)
  end 
  
  def find_post
    @post = Post.find(params[:id])
  end
    
end
