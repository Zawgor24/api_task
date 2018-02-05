require 'rails_helper'

RSpec.describe 'Post API', type: :request do
  let(:user) { create(:user) }
  let!(:posts) { create_list(:post, 10, user_id: user.id) }
  let(:post_id) { posts.first.id }

  describe 'GET /api/v1/posts' do
    before { get '/api/v1/posts' }

    it { expect(response).to have_http_status(200) }

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
      let(:post_id) { 0 }

      it { expect(response).to have_http_status(404) }
    end
  end

  describe 'POST /api/v1/posts' do
    context 'when the request is valid' do
      let(:valid_attributes) { { title: 'Test', body: 'Api' } }

      before { post "/api/v1/posts/?auth_token=#{user.authentication_token}", params: valid_attributes }

      it { expect(response).to have_http_status(201) }

      it 'creates post' do
        expect(json_data['data']['title']).to eq('Test')
      end
    end

    context 'when the request is not valid' do
      before { post "/api/v1/posts/?auth_token=#{user.authentication_token}", params: { title: 'error' } }

      it { expect(response).to have_http_status(422) }

      it { expect(json_data['message']).to eq('ERROR') }
    end
  end

  describe 'PUT /api/v1/posts/:id' do
    let(:valid_attributes) { { title: 'Action', body: 'Update' } }

    context 'when the record exist' do
      before { put "/api/v1/posts/#{post_id}", params: valid_attributes }

      it { expect(json_data['message']).to eq('SUCCESS') }
    end
  end

  describe 'DELETE /api/v1/posts/:id' do
    before { delete "/api/v1/posts/#{post_id}" }

    it { expect(response).to have_http_status(200) }
  end

  private

  def json_data
    JSON.parse(response.body)
  end
end
