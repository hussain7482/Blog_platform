# app/controllers/posts_controller.rb
class PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:edit, :update, :show, :approve, :reject, :publish, :submit_for_approval, :request_revision ]
    before_action :authorize_post, only: [:edit, :update, :approve, :reject, :publish]

    def index
        @posts = Post.where(status: 'published')
    end

    def unpublished_posts
        @unpublished_posts = current_user.posts.where.not(status: 'published')
      end
  
    def new
      @post = current_user.posts.build
    end
  
    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        @post.create_history(:created, current_user)
        redirect_to @post, notice: 'Post created successfully, awaiting approval.'
      else
        render :new
      end
    end
  
    def edit
    end
  
    def update
      if @post.update(post_params)
        @post.create_history(:edited, current_user)
        redirect_to @post, notice: 'Post updated successfully.'
      else
        render :edit
      end
    end
  
    def approve
      @post.update(status: :approved)
      @post.create_history(:approved, current_user, params[:comment])
      PostMailer.post_approved(@post, @post.user).deliver_now
      redirect_to @post, notice: 'Post approved by editor, awaiting final admin approval.'
    end
  
    def reject
      @post.update(status: :rejected)
      @post.create_history(:rejected, current_user, params[:comment])
      PostMailer.post_rejected(@post, @post.user).deliver_now
      redirect_to @post, notice: 'Post rejected by editor.'
    end
  
    def publish
      @post.update(status: :published)
      @post.create_history(:published, current_user)
      PostMailer.post_published(@post, @post.user).deliver_now
      redirect_to @post, notice: 'Post published!'
    end

    def submit_for_approval
      if @post.update(status: 'pending_approval')
        redirect_to manage_posts_path, notice: 'Post submitted for approval.'
      else
        redirect_to unpublished_posts_path, alert: 'Unable to submit post.'
      end
    end

    def manage
      if current_user.role == 'editor'
        @posts = Post.where(status: 'pending_approval')
      elsif current_user.role == 'admin'
        @posts = Post.where(status: 'approved')
      elsif current_user.role == 'author'
        @posts = Post.where.not(status: 'published')
      else
        redirect_to root_path, alert: "You don't have permission to manage posts."
      end
    end

    def request_revision
      @post.update(status: :pending_revision)
      @post.create_history(:pending_revision, current_user, params[:comment])
      PostMailer.post_request_revision(@post, @post.user).deliver_now
      redirect_to @post, notice: 'Post sent back for revision.'
    end

    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def post_params
      params.require(:post).permit(:title, :content, :image)
    end
  
    def authorize_post
      # Author can only edit their own posts
      if current_user.role == "author"
        redirect_to root_path, alert: "Not authorized" unless @post.user == current_user
      # Editor can approve/reject posts in pending approval
      elsif current_user.role == "editor"
        redirect_to root_path, alert: "Not authorized" unless @post.status == "pending_approval"
      # Admin can approve and publish posts
      elsif current_user.role == "admin"
        redirect_to root_path, alert: "Not authorized" unless @post.status == "approved"
      end
    end
  end
  