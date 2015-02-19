class PostsController < ApplicationController
  
  load_and_authorize_resource
  skip_load_resource only: [:create]


  def index
 @posts = Post.select('posts.*, (select avg(rating) from comments where post_id = posts.id) as avg')
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
 
  if @post.save
    redirect_to @post
  else
    render 'new'
  end
 end
 
  def show    
    
    @post = Post.find(params[:id])
    
     if @post.comments.blank?
      @avg_comments = 0
    else
      @avg_comments = @post.comments.average(:rating).round(2)
    end
   
    authorize! :read, @post
    
  end
  
  def edit
    
  end
 
  def update
    
    @post = Post.find(params[:id])
 
    if @post.update(post_params)
      redirect_to @post
    else
      render 'edit'
    end
  end
  
   def destroy
    @post = Post.find(params[:id])
    @post.destroy
 
    redirect_to posts_path
  end
  
  private
 
  def post_params
    params.require(:post).permit(:title, :body, :image)
  end 
  
end
