Rails.application.routes.draw do
  root 'page#index'

  get '/admin', to: 'admin#index'
  get '/admin/items', to: 'admin#items'
  get '/admin/categories', to: 'admin#categories'
  get '/admin/collections', to: 'admin#collections'
  get '/admin/add2collection', to: 'admin#add2collection'

  match '/admin/discount'  => 'admin#discount',    via: [:post,:get]
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
  match '/wishlist(/:item_id)'  => 'cart#add_to_wishlist', via: [:get]
  get '/remove(/:id)', to: 'cart#removeitem'
  match '/discount'  => 'cart#applydiscount', via: [:post , :get]

  get '/profile', to: 'page#profile'

  get '/category(/:name)', to: 'page#showcategory'
  get '/subcategory(/:name)', to: 'page#showsubcategory'
  get '/product(/:item_name)', to: 'page#showitem'
  get '/order', to: 'page#order_info'
  match '/checkout'  => 'page#checkout', via: [:post, :get]
  match '/placeorder'  => 'page#placeorder', via: [:post, :get]


end
