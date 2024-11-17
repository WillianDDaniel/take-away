# Restaurant Owner
user = User.create!(
  email: 'user@email.com', name: 'John', last_name: 'Doe',
  password: '123456789123', document_number: CPF.generate
)

restaurant = Restaurant.create!(
  brand_name: 'Divinos', corporate_name: 'Hambúrgueria', doc_number: CNPJ.generate,
  email: 'divinos@email.com', phone: '11999999999', address: 'Rua Exemplo 11', user: user
)

# Registered employee /staff
employee_doc = CPF.generate
Employee.create!(email: 'employee@example.com', doc_number: employee_doc, restaurant: restaurant)

User.create!(
  email: 'employee@example.com', name: 'Maria', last_name: 'Doe',
  password: '123456789123', document_number: employee_doc
)

# Unregistered employee/staff
Employee.create!(email: 'otheremployee@example.com', doc_number: CPF.generate, restaurant: restaurant)

# Menus
menu_almoco = Menu.create!(name: 'Almoço', restaurant: restaurant)
menu_cafe = Menu.create!(name: 'Café da manhã', restaurant: restaurant)
menu_lanches = Menu.create!(name: 'Lanches', restaurant: restaurant)

def create_portions(item, prices)
  prices.each_with_index do |(description, price), index|
    item.portions.create!(description: description, price: price)
  end
end

# Dishes
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

dish_07 = Dish.create!(name: 'Fettuccine ao Fungi',
  description: 'Massa artesanal com mix de cogumelos frescos e molho bechamel',
  calories: 450, restaurant: restaurant
)
create_portions(dish_07, { 'Individual' => 32.0, 'Para Dois' => 58.0 })

dish_08 = Dish.create!(name: 'Nhoque da Casa',
  description: 'Nhoque de batata com molho pomodoro e manjericão fresco',
  calories: 380, restaurant: restaurant
)
create_portions(dish_08, { 'Individual' => 28.0, 'Família' => 65.0 })

dish_09 = Dish.create!(
  name: 'Caesar Suprema',
  description: 'Mix de folhas, frango grelhado, croutons e molho caesar',
  calories: 280, restaurant: restaurant
)
create_portions(dish_09, { 'Entrada' => 22.0, 'Refeição' => 34.0, 'Para Compartilhar' => 48.0 })

dish_10 = Dish.create!(
  name: 'Bowl Mediterrâneo',
  description: 'Quinoa, grão-de-bico, homus, falafel e molho tahine',
  calories: 320, restaurant: restaurant
)
create_portions(dish_10, { 'Bowl Clássico' => 29.0, 'Super Bowl' => 42.0 })

dish_11 = Dish.create!(
  name: 'Salmão Grelhado',
  description: 'Filé de salmão com crosta de ervas e legumes ao vapor',
  calories: 420, restaurant: restaurant
)
create_portions(dish_11, { 'Classic' => 45.0, 'Premium' => 62.0 })

dish_12 = Dish.create!(
  name: 'Picanha na Brasa',
  description: 'Picanha grelhada com arroz, farofa e vinagrete',
  calories: 580, restaurant: restaurant
)
create_portions(dish_12, { 'Solo' => 52.0, 'Duo' => 98.0, 'Família' => 145.0 })

dish_13 = Dish.create!(
  name: 'Curry de Legumes',
  description: 'Mix de legumes com curry indiano e leite de coco, acompanha arroz integral',
  calories: 290, restaurant: restaurant
)
create_portions(dish_13, { 'Tigela' => 26.0, 'Panela' => 48.0 })

dish_14 = Dish.create!(
  name: 'Paella Marinera',
  description: 'Arroz com açafrão, camarões, lulas, mariscos e pescado do dia',
  calories: 460, restaurant: restaurant
)
create_portions(dish_14, { 'Individual' => 68.0, 'Casal' => 125.0, 'Família (4 pessoas)' => 230.0 })

dish_15 = Dish.create!(
  name: 'Petit Gateau',
  description: 'Bolo quente de chocolate com sorvete de baunilha',
  calories: 380, restaurant: restaurant
)
create_portions(dish_15, { 'Classic' => 22.0, 'Double' => 38.0 })

dish_16 = Dish.create!(
  name: 'Tiramisù',
  description: 'Sobremesa italiana com café, mascarpone e cacau',
  calories: 320, restaurant: restaurant
)
create_portions(dish_16, { 'Taça' => 18.0, 'Para Compartilhar' => 32.0 })

dish_17 = Dish.create!(
  name: 'Feijoada Completa',
  description: 'Feijoada tradicional com acompanhamentos',
  calories: 850,
  restaurant: restaurant
)
create_portions(dish_17, { 'Individual' => 42.0, 'Família (3-4 pessoas)' => 120.0, 'Festiva (6-8 pessoas)' => 220.0 })

dish_18 = Dish.create!(
  name: 'Moqueca de Peixe',
  description: 'Peixe fresco com leite de coco, dendê e pimentões, acompanha arroz e pirão',
  calories: 440, restaurant: restaurant
)
create_portions(dish_18, { 'Individual' => 48.0, 'Casal' => 89.0, 'Panela Grande' => 165.0 })

# Menu Café (breakfast)
menu_cafe.dishes << [
  dish_06,  # X-Salada Light (repetido no almoço)
  dish_08,  # Nhoque da Casa (repetido no almoço)
  dish_09,  # Caesar Suprema
  dish_10,  # Bowl Mediterrâneo
  dish_15,  # Petit Gateau
  dish_16   # Tiramisù
]

# Menu Almoço (lunch)
menu_almoco.dishes << [
  dish_06,  # X-Salada Light (repetido do café)
  dish_08,  # Nhoque da Casa (repetido do café)
  dish_11,  # Salmão Grelhado
  dish_12,  # Picanha na Brasa
  dish_13,  # Curry de Legumes
  dish_14,  # Paella Marinera
  dish_17,  # Feijoada Completa
  dish_18   # Moqueca de Peixe
]

# Menu Lanches (snacks/dinner)
menu_lanches.dishes << [
  dish_01,  # X-Burguer
  dish_02,  # X-Salada Especial
  dish_03,  # Veggie Burger
  dish_04,  # Chicken Burger
  dish_05,  # Cheese Bacon
  dish_07,  # Fettuccine ao Fungi (repetido do almoço)
  dish_15   # Petit Gateau (repetido do café)
]

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

beverage_07 = Beverage.create!(name: 'Caipirinha', description: 'Drink tradicional com limão, cachaça e açúcar',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_07, { 'Clássica' => 16.0, 'Premium' => 22.0, 'Jarra' => 45.0 })

beverage_08 = Beverage.create!(name: 'Smoothie Verde', description: 'Blend de frutas verdes, spirulina e hortelã',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_08, { 'Regular' => 14.0, 'Super' => 19.0 })

beverage_09 = Beverage.create!(name: 'Mojito', description: 'Drink cubano com rum, hortelã e limão',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_09, { 'Classic' => 18.0, 'Double' => 28.0, 'Pitcher' => 52.0 })

beverage_10 = Beverage.create!(name: 'Kombucha', description: 'Chá fermentado com frutas vermelhas',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_10, { 'Copo' => 12.0, 'Garrafa 500ml' => 22.0 })

beverage_11 = Beverage.create!(name: 'Espumante', description: 'Espumante brut nacional',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_11, { 'Taça' => 20.0, 'Garrafa' => 85.0 })

beverage_12 = Beverage.create!(name: 'Limonada Suíça', description: 'Limão batido com leite condensado e hortelã',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_12, { 'Individual' => 9.0, 'Jarra 500ml' => 18.0, 'Jarra 1L' => 32.0 })

beverage_13 = Beverage.create!(name: 'Whisky Single Malt', description: '12 anos, servido com gelo',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_13, { 'Dose 45ml' => 28.0, 'Dose Dupla' => 52.0, 'Garrafa' => 280.0 })

beverage_14 = Beverage.create!(name: 'Café Especial', description: 'Blend especial da casa',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_14, { 'Espresso' => 5.0, 'Duplo' => 8.0, 'Jarra' => 15.0 })

beverage_15 = Beverage.create!(name: 'Gin Tônica', description: 'Gin premium com tônica artesanal e especiarias',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_15, { 'Classic' => 24.0, 'Premium' => 32.0, 'Jarra' => 68.0 })

beverage_16 = Beverage.create!(name: 'Água de Coco', description: 'Água de coco natural gelada',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_16, { 'Copo 300ml' => 8.0, 'Coco Verde' => 12.0 })

beverage_17 = Beverage.create!(name: 'Sangria', description: 'Vinho tinto com frutas da estação',
  alcoholic: true, restaurant: restaurant)
create_portions(beverage_17, { 'Taça' => 16.0, 'Jarra 500ml' => 42.0, 'Jarra 1L' => 75.0 })

beverage_18 = Beverage.create!(name: 'Milkshake', description: 'Shake cremoso de chocolate belga',
  alcoholic: false, restaurant: restaurant)
create_portions(beverage_18, { 'Classic' => 16.0, 'Super' => 22.0, 'Família' => 38.0 })

# Menu Café (breakfast)
menu_cafe.beverages << [
 beverage_01,  # Suco de Laranja
 beverage_03,  # Chá Gelado
 beverage_06,  # Água Mineral
 beverage_08,  # Smoothie Verde
 beverage_14,  # Café Especial
 beverage_16,  # Água de Coco
 beverage_18   # Milkshake
]

# Menu Almoço (lunch)
menu_almoco.beverages << [
 beverage_02,  # Refrigerante
 beverage_03,  # Chá Gelado (repetido do café)
 beverage_06,  # Água Mineral (repetido do café)
 beverage_10,  # Kombucha
 beverage_12,  # Limonada Suíça
 beverage_16,  # Água de Coco (repetido do café)
 beverage_17   # Sangria
]

# Menu Lanches (snacks/dinner)
menu_lanches.beverages << [
 beverage_02,  # Refrigerante (repetido do almoço)
 beverage_04,  # Cerveja Artesanal
 beverage_05,  # Vinho Tinto
 beverage_07,  # Caipirinha
 beverage_09,  # Mojito
 beverage_13,  # Whisky Single Malt
 beverage_15   # Gin Tônica
]

tag_01 = Tag.create!(name: 'Promoção', restaurant: restaurant)
tag_02 = Tag.create!(name: 'Especial', restaurant: restaurant)
tag_03 = Tag.create!(name: 'Favorito', restaurant: restaurant)
tag_04 = Tag.create!(name: 'Queridinho', restaurant: restaurant)
tag_05 = Tag.create!(name: 'Sensacional', restaurant: restaurant)
tag_06 = Tag.create!(name: 'Da casa', restaurant: restaurant)
tag_07 = Tag.create!(name: 'Vegano', restaurant: restaurant)
tag_08 = Tag.create!(name: 'Fit', restaurant: restaurant)
tag_09 = Tag.create!(name: 'Premium', restaurant: restaurant)
tag_10 = Tag.create!(name: 'Chef', restaurant: restaurant)
tag_11 = Tag.create!(name: 'Regional', restaurant: restaurant)
tag_12 = Tag.create!(name: 'Novo', restaurant: restaurant)

# Pratos originais (1-6)
dish_01.tags << [tag_01, tag_05, tag_06]  # X-Burguer
dish_02.tags << [tag_02, tag_05, tag_04]  # X-Salada Especial
dish_03.tags << [tag_03, tag_05, tag_07]  # Veggie Burger
dish_04.tags << [tag_04, tag_05, tag_08]  # Chicken Burger
dish_05.tags << [tag_01, tag_05, tag_03]  # Cheese Bacon
dish_06.tags << [tag_02, tag_08, tag_01]  # X-Salada Light

# Massas (7-8)
dish_07.tags << [tag_10, tag_09, tag_06]  # Fettuccine ao Fungi
dish_08.tags << [tag_06, tag_02, tag_12]  # Nhoque da Casa

# Saladas (9-10)
dish_09.tags << [tag_08, tag_04, tag_12]  # Caesar Suprema
dish_10.tags << [tag_07, tag_08, tag_03]  # Bowl Mediterrâneo

# Pratos Principais (11-12)
dish_11.tags << [tag_09, tag_10, tag_04]  # Salmão Grelhado
dish_12.tags << [tag_09, tag_02, tag_05]  # Picanha na Brasa

# Pratos Veganos e Frutos do Mar (13-14)
dish_13.tags << [tag_07, tag_08, tag_12]  # Curry de Legumes
dish_14.tags << [tag_09, tag_10, tag_02]  # Paella Marinera

# Sobremesas (15-16)
dish_15.tags << [tag_06, tag_03, tag_05]  # Petit Gateau
dish_16.tags << [tag_06, tag_09, tag_03]  # Tiramisù

# Pratos Regionais (17-18)
dish_17.tags << [tag_11, tag_06, tag_03]  # Feijoada Completa
dish_18.tags << [tag_11, tag_10, tag_02]  # Moqueca de Peixe

# Create 10 varied orders
10.times do |i|
  # Create random order items for each order
  order_items = []

  # Add 1-4 random dishes to each order
  rand(1..4).times do
    dish = Dish.all.sample
    portion = dish.portions.sample

    order_items << OrderItem.new(
      portion: portion,
      quantity: rand(1..3),
      note: [nil, 'Sem cebola', 'Bem passado', 'Sem pimenta', 'Extra queijo'].sample
    )
  end

  # Add 1-3 random beverages to each order
  rand(1..3).times do
    beverage = Beverage.all.sample
    portion = beverage.portions.sample

    order_items << OrderItem.new(
      portion: portion,
      quantity: rand(1..2)
    )
  end

  # Array of emails that we know are valid
  emails = [
    'maria.silva@email.com',
    'joao.santos@email.com',
    'ana.oliveira@email.com',
    'pedro.lima@email.com',
    'julia.costa@email.com',
    'lucas.pereira@email.com',
    'carla.souza@email.com',
    'rafael.almeida@email.com',
    'beatriz.rodrigues@email.com',
    'thiago.ferreira@email.com'
  ]

  # Create fake customer data
  customer_names = [
    'Maria Silva', 'João Santos', 'Ana Oliveira', 'Pedro Lima',
    'Julia Costa', 'Lucas Pereira', 'Carla Souza', 'Rafael Almeida',
    'Beatriz Rodrigues', 'Thiago Ferreira'
  ]

  # Generate a random phone number
  phone_number = "11#{rand(9..9)}#{rand(8..9)}#{rand(100..999)}#{rand(1000..9999)}"

  # Create the order
  Order.create!(
    customer_name: customer_names[i],
    customer_phone: phone_number,
    customer_email: emails[i],
    customer_doc: CPF.generate,
    order_items: order_items,
    menu: Menu.all.sample,
    created_at: rand(7.days).seconds.ago # Add some variety to order dates
  )
end

puts "Seed carregada com sucesso!"
