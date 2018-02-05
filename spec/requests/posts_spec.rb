require 'rails_helper'

RSpec.describe 'Post API', type: :request do
  let(:user) { create(:user) }
  let!(:posts) { create_list(:post, 10, user_id: user.id) }
  # let(:post) { create(:post, user_id: user.id) }
  let(:post_id) { posts.first.id }

  let(:valid_attributes) { { email: user.email, password: user.password } }
  before { post '/auth/sign_in', params: valid_attributes }

  describe 'GET /api/v1/posts' do
    before { get '/api/v1/posts' }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns posts' do 
      expect(json_data.size).to eq(10)
    end
  end

  describe 'GET /api/v1/posts/:id' do
    before { get "/api/v1/posts/#{post_id}" }

    context 'when the post exist' do
      it { expect(json_data['id']).to eq(post_id) }

      it { expect(response).to have_http_status(200) }
    end

    context 'when the record does not exist' do
      # let(:post_id) { Post.all.pluck(:id).max + 1 }

      # it { expect(json_data['id']).not_to (post_id) }

      # it { expect(response).to have_http_status(404) }
    end
  end

  describe 'POST /api/v1/posts' do
    let(:valid_attributes) { { title: 'asd', body: 'asd', user_id: user.id } }

    context 'when the request is valid' do
      before { post '/api/v1/posts', params: valid_attributes }

      # it 'a' do
      #   expect(json_data[:title]).to eq(valid_attributes.title) 
      # end

      it { expect(response).to have_http_status(200) }
    end

    context 'when the request is not valid' do

    end
  end

  # describe 'POST /auth/sign_in' do 

  #   it 'returns status code 200' do
  #     expect(response).to have_http_status(200)
  #   end
  # end

  def json_data
    JSON.parse(response.body)
  end
end
