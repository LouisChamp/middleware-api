class MockController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :initialize_avatar_mapper
  after_action :display_avatar_mapper_cache

  def profile
    response = HTTParty.get('https://taggram.herokuapp.com/me')

    json_response = JSON.parse(response.body)

    if response.code == 200
      json_response['avatar'] = cache_for(json_response['avatar'])
    end

    render json: json_response, status: response.code
  end

  def read_post
    response = HTTParty.get('https://taggram.herokuapp.com/post')

    json_response = JSON.parse(response.body)

    if response.code == 200
      json_response['user']['avatar'] = cache_for(json_response['user']['avatar'])

      json_response['comments'].each do |comment|
        comment['user']['avatar'] = cache_for(comment['user']['avatar'])
      end
    end

    render json: json_response, status: response.code
  end

  def add_comment
    response = HTTParty.post(
      "https://taggram.herokuapp.com/posts/#{params[:uuid]}/comments",
      body: {
        username: params[:username],
        message: params[:message]
      }.to_json,
      headers: { 'Content-Type' => 'application/json' },
      # debug_output: $stdout
    )

    json_response = JSON.parse(response.body) rescue nil

    if response.code == 200
      json_response.each do |comment|
        comment['user']['avatar'] = cache_for(comment['user']['avatar'])
      end
    end

    render json: json_response, status: response.code
  end

  private

  def generate_random_avatar
    "https://i.pravatar.cc/150?img=#{rand(70) + 1}"
  end

  def initialize_avatar_mapper
    session[:avatar_mapper] ||= {}
  end

  def cache_for(avatar)
    session[:avatar_mapper][avatar] ||= generate_random_avatar unless avatar.nil?
  end

  def display_avatar_mapper_cache
    puts '-----------'
    p session[:avatar_mapper]
    puts '-----------'
  end
end
