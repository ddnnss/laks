Rails.application.routes.draw do
  root 'page#index'


  get '/admin/items', to: 'admin#items'
  get '/admin/categories', to: 'admin#categories'
  match '/addnewcategory'  => 'admin#addnewcategory',    via: [:post]
  match '/addnewsubcategory'  => 'admin#addnewsubcategory',    via: [:post]
  match '/admin/deletecategory'  => 'admin#deletecategory',    via: [:get]


end
