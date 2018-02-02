class Api::V1::PostsController < ApplicationController
  before_action :find_post, only: %i[show update destroy]

  def index
    @posts = Post.all

    render json: @posts, status: :ok
  end

  def create
    @post = Post.new(post_params)

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

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
