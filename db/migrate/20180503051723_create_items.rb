class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.belongs_to :subcategory
      t.belongs_to :collection
      t.belongs_to :aktion
      t.string     :item_name                                             #название товара
      t.string     :item_name_caps, index:true                            #поле для тех. нужд
      t.string     :item_name_translit, :default => '', index: true       #поле для тех. нужд
      t.string     :item_image1, :default => 'none'                       #изображение товара 1 (обязательное)
      t.string     :item_image2, :default => 'none'                       #изображение товара 2 (необязательное)
      t.string     :item_image3, :default => 'none'                       #изображение товара 3 (необязательное)
      t.string     :item_image4, :default => 'none'                       #изображение товара 4 (необязательное)
      t.string     :item_size_d, :default => '0'
      t.string     :item_size_sh, :default => '0'
      t.string     :item_size_v, :default => '0'                            #размер товара
      t.string     :item_article, :default => 'не указано'                #артикул товара
      t.string     :item_weight, :default => 'не указано'                 #вес товара
      t.string     :item_color, :default => 'не указано'
      t.string     :item_material, :default => 'не указано'
      t.string     :item_postavshik, :default => ''
      t.string     :item_filter, :default => ''

      t.text       :item_description, :default => ''                      #описание товара
      t.text       :item_comment, :default => ''

      t.string     :item_page_title, :default => ''                       #название страницы с  товаром
      t.string     :item_page_description, :default => ''                 #описание страницы товара(МЕТА ТЭГ)

      t.integer    :item_price , index: true                              #обычная цена товара
      t.integer    :item_opt_price                                        #оптовая цена товара
      t.integer    :item_opt_price_count                                  #кол-во едениц товара нужно купить для оптовой цены
      t.integer    :item_discount, :default => 0                          #скидка на товар в %
      t.integer    :item_views_count, :default => 0                       #кол-во просмотров товара
      t.integer    :item_kolvo, :default => 0

      t.boolean     :item_in_sale, :default => false, index: true          #отметка что на этот товар есть скидка
      t.boolean     :item_in_collection, :default => false, index: true    #отметка что этот товар в коллекции
      t.boolean     :item_new, :default => false, index: true              #отметка что этот товар в новинка
      t.boolean     :item_presents, :default => true

      t.string      :item_temp1
      t.string      :item_temp2
      t.string      :item_temp3
      t.string      :item_temp4
      t.timestamps
    end
  end
end