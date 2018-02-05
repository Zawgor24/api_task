class Api::V1::PostsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :find_post, only: %i[show update destroy]
  before_action :find_user, only: %(create)

  def index
    @posts = Post.all

    render json: @posts, status: :ok
  end

  def show
    render json: @post, status: :ok
  end

  def create
    @post = @user.posts.new(post_params)

    if @post.save
      render json: { message: 'SUCCESS', data: @post }, status: :created
    else
      render json: { message: 'ERROR', data: @post.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: { message: 'SUCCESS', data: @post }, status: :updated
    else
      render json: { message: 'ERROR', data: @post.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      head(:ok)
    else
      head(:unprocessable_entity)
    end
  end

  private

  def record_not_found
    render text: '404 Not Found', status: 404
  end

  def find_user
    @user ||= User.find_by(authentication_token: params[:auth_token])
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.permit(:title, :body)
  end
end
