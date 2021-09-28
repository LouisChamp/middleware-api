# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'me' => 'mock#profile'
  get 'post' => 'mock#read_post'
  post 'posts/:uuid/comments' => 'mock#add_comment'
end
