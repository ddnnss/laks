Rails.application.routes.draw do
  root 'page#index'


  get '/admin/items', to: 'admin#items'
  get '/admin/categories', to: 'admin#categories'
  get '/admin/collections', to: 'admin#collections'
  get '/admin/add2collection', to: 'admin#add2collection'
  match '/addnewcategory'  => 'admin#addnewcategory',    via: [:post]
  match '/addnewsubcategory'  => 'admin#addnewsubcategory',    via: [:post]
  match '/admin/deletecategory'  => 'admin#deletecategory',    via: [:get]
  match '/admin/editcategory'  => 'admin#editcategory', via: [:post]
  match '/admin/additem'  => 'admin#additem', via: [:post, :get]
  match '/addnewitem'  => 'admin#addnewitem', via: [:post]
  match '/addcollection'  => 'admin#addcollection',    via: [:post]
  match '/editcollection'  => 'admin#editcollection', via: [:post]

  match '/login'  => 'client#login', via: [:post]
  match '/registration'  => 'client#registration', via: [:post]
  match '/logout'  => 'client#logout', via: [:get]
  get '/activate', to: 'client#activate'

  match '/addtocart(/:item_id)'  => 'cart#addtocart', via: [:get]


  get '/category(/:name)', to: 'page#showcategory'
  get '/subcategory(/:name)', to: 'page#showsubcategory'


end
