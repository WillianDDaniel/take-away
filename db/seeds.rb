# Usuário e Restaurante
user = User.create!(
  email: 'user@email.com', name: 'John', last_name: 'Doe',
  password: '123456789123', document_number: CPF.generate
)

restaurant = Restaurant.create!(
  brand_name: 'Divinos', corporate_name: 'Hambúrgueria', doc_number: CNPJ.generate,
  email: 'divinos@email.com', phone: '11999999999', address: 'Rua Exemplo 11', user: user
)

menu_almoco = Menu.create!(name: 'Almoço', restaurant: restaurant)
menu_cafe = Menu.create!(name: 'Café da manhã', restaurant: restaurant)
menu_lanches = Menu.create!(name: 'Lanches', restaurant: restaurant)

def create_portions(item, prices)
  prices.each_with_index do |(description, price), index|
    item.portions.create!(description: description, price: price)
  end
end

dish_01 = Dish.create!(name: 'X-Burguer', description: 'Hambúrguer clássico com queijo e alface',
  calories: 500, restaurant: restaurant)
create_portions(dish_01, { 'Pequeno' => 12.0, 'Médio' => 18.0, 'Grande' => 25.0 })

dish_02 = Dish.create!(name: 'X-Salada Especial', description: 'Hambúrguer com queijo, alface, tomate e maionese especial',
  calories: 400, restaurant: restaurant)
create_portions(dish_02, { 'Pequeno' => 14.0, 'Médio' => 20.0, 'Grande' => 28.0 })

dish_03 = Dish.create!(name: 'Veggie Burger', description: 'Hambúrguer vegetariano com grão-de-bico e especiarias',
  calories: 300, restaurant: restaurant)
create_portions(dish_03, { 'Pequeno' => 15.0, 'Médio' => 22.0, 'Grande' => 30.0 })

dish_04 = Dish.create!(name: 'Chicken Burger', description: 'Sanduíche de frango grelhado com molho de iogurte',
  calories: 350, restaurant: restaurant)
create_portions(dish_04, { 'Pequeno' => 13.0, 'Médio' => 19.0, 'Grande' => 27.0 })

dish_05 = Dish.create!(name: 'Cheese Bacon', description: 'Hambúrguer com queijo cheddar e bacon crocante',
  calories: 600, restaurant: restaurant)
create_portions(dish_05, { 'Pequeno' => 16.0, 'Médio' => 23.0, 'Grande' => 31.0 })

dish_06 = Dish.create!(name: 'X-Salada Light', description: 'Versão light com pão integral e queijo branco',
  calories: 250, restaurant: restaurant)
create_portions(dish_06, { 'Pequeno' => 12.0, 'Médio' => 18.0, 'Grande' => 26.0 })

[menu_almoco, menu_cafe, menu_lanches].each do |menu|
  menu.dishes << [dish_01, dish_02, dish_03, dish_04, dish_05, dish_06]
end

beverage_01 = Beverage.create!(name: 'Suco de Laranja', description: 'Suco natural de laranja',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_01, { 'Pequeno' => 8.0, 'Médio' => 12.0, 'Grande' => 16.0 })

beverage_02 = Beverage.create!(name: 'Refrigerante', description: 'Refrigerante de cola',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_02, { 'Pequeno' => 6.0, 'Médio' => 10.0, 'Grande' => 14.0 })

beverage_03 = Beverage.create!(name: 'Chá Gelado', description: 'Chá verde com hortelã e gelo',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_03, { 'Pequeno' => 7.0, 'Médio' => 11.0, 'Grande' => 15.0 })

beverage_04 = Beverage.create!(name: 'Cerveja Artesanal', description: 'Cerveja artesanal tipo IPA',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_04, { 'Pequeno' => 10.0, 'Médio' => 15.0, 'Grande' => 20.0 })

beverage_05 = Beverage.create!(name: 'Vinho Tinto', description: 'Vinho tinto seco',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_05, { 'Taça' => 18.0, 'Garrafa' => 75.0 })

beverage_06 = Beverage.create!(name: 'Água Mineral', description: 'Água mineral sem gás',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_06, { 'Pequeno' => 3.0, 'Médio' => 5.0, 'Grande' => 7.0 })

[menu_almoco, menu_cafe, menu_lanches].each do |menu|
  menu.beverages << [beverage_01, beverage_02, beverage_03, beverage_04, beverage_05, beverage_06]
end

tag_01 = Tag.create!(name: 'Promoção', restaurant: restaurant)
tag_02 = Tag.create!(name: 'Especial', restaurant: restaurant)
tag_03 = Tag.create!(name: 'Favorito', restaurant: restaurant)
tag_04 = Tag.create!(name: 'Queridinho', restaurant: restaurant)
tag_05 = Tag.create!(name: 'Sensacional', restaurant: restaurant)
tag_06 = Tag.create!(name: 'Da casa', restaurant: restaurant)

dish_01.tags << tag_01
dish_01.tags << tag_05
dish_01.tags << tag_06

dish_02.tags << tag_02
dish_02.tags << tag_05
dish_02.tags << tag_04

dish_03.tags << tag_03
dish_03.tags << tag_05
dish_03.tags << tag_02

dish_04.tags << tag_04
dish_04.tags << tag_05
dish_04.tags << tag_06

dish_05.tags << tag_01
dish_05.tags << tag_05
dish_05.tags << tag_03

dish_06.tags << tag_02
dish_06.tags << tag_05
dish_06.tags << tag_01


puts "Seed carregada com sucesso!"
