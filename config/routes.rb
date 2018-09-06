Rails.application.routes.draw do
  root 'page#index'

  get '/admin', to: 'admin#index'
  get '/admin/items', to: 'admin#items'
  get '/admin/getsubcat', to: 'admin#getsubcat'
  get '/admin/categories', to: 'admin#categories'
  get '/admin/homepage', to: 'admin#homepage'
  get '/admin/collections', to: 'admin#collections'
  get '/admin/aktions', to: 'admin#aktions'
  get '/admin/add2collection', to: 'admin#add2collection'
  get '/admin/collremove', to: 'admin#removefromcollection'
  get '/admin/actremove', to: 'admin#removefromaktion'
  get '/admin/showsubcategory', to: 'admin#showsubcategory'

  match '/admin/edititem'  => 'admin#edititem', via: [:post, :get]
  match '/admin/orders'  => 'admin#orders', via: [:get , :post]
  match '/admin/sendmail'  => 'admin#sendmail', via: [:get , :post]
  match '/admin/sendmailaction'  => 'admin#sendmailaction', via: [ :post]
  match '/admin/savemail'  => 'admin#savemail', via: [ :post, :get]
  match '/admin/editmail'  => 'admin#editmail', via: [ :get]
  match '/admin/order_info'  => 'admin#order_info', via: [:get]
  match '/admin/deleteitem'  => 'admin#deleteitem', via: [:post, :get]
  match '/admin/delimg'  => 'admin#delimg', via: [:post, :get]
  match '/admin/deleteaktion'  => 'admin#deleteaktion',    via: [:get]
  match '/admin/deletecollection'  => 'admin#deletecollection',    via: [:get]
  match '/addaktion'  => 'admin#addaktion',    via: [:post]
  match '/editaktion'  => 'admin#editaktion', via: [:post]
  match '/admin/discount'  => 'admin#discount',    via: [:post,:get]
  match '/addnewcategory'  => 'admin#addnewcategory',    via: [:post]
  match '/addnewsubcategory'  => 'admin#addnewsubcategory',    via: [:post]
  match '/admin/deletecategory'  => 'admin#deletecategory',    via: [:get]
  match '/admin/editcategory'  => 'admin#editcategory', via: [:post]
  match '/admin/additem'  => 'admin#additem', via: [:post, :get]
  match '/addnewitem'  => 'admin#addnewitem', via: [:post]
  match '/addcollection'  => 'admin#addcollection',    via: [:post]
  match '/editcollection'  => 'admin#editcollection', via: [:post]
  match '/addslide'  => 'admin#addslide', via: [:post, :get]

  match '/login'  => 'client#login', via: [:post]
  match '/lostpass'  => 'client#lostpass', via: [:post]
  match '/search'  => 'page#search', via: [:post , :get]
  match '/login'  => 'page#login_mobile', via: [:get]
  match '/registration'  => 'client#registration', via: [:post]
  match '/logout'  => 'client#logout', via: [:get]
  get '/activate', to: 'client#activate'

  match '/addtocart(/:item_id)'  => 'cart#addtocart', via: [:get]
  match '/addtocartalt(/:item_id)(/:val)'  => 'cart#addtocartalt', via: [:get]
  match '/wishlist(/:item_id)'  => 'cart#add_to_wishlist', via: [:get]
  match '/order(/:order_code)'  => 'page#orderstatus', via: [:get]
  get '/remove(/:id)', to: 'cart#removeitem'
  match '/discount'  => 'cart#applydiscount', via: [:post , :get]


  match '/profile'  => 'page#profile', via: [:post, :get]

  get '/category(/:name)', to: 'page#showcategory'
  get '/subcategory(/:name)', to: 'page#showsubcategory'
  get '/collection(/:name)', to: 'page#showcollection'
  get '/product(/:item_name)', to: 'page#showitem'
  get '/order', to: 'page#order_info'
  match '/checkout'  => 'page#checkout', via: [:post, :get]
  match '/placeorder'  => 'page#placeorder', via: [:post, :get]


end
