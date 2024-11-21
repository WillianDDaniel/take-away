# Projeto PaLevá (Take Away)

Projeto em desenvolvimento para o sistema **PaLevá (Take Away)**, um aplicativo web para gerenciamento de cardápio de um restaurante, permitindo que os proprietários de restaurantes cadastrem pratos e bebidas e criação de pedidos de forma organizada e eficiente.

## Principais Funcionalidades
- Registro e gerenciamento de pratos com características como "vegetariano", "vegano", "sem glúten", entre outros.
- Cadastro de bebidas.
- Cadastro de porções e preços com histórico para acompanhar alterações.
- Cadastro de funcionários com autorização para criação de pedidos.
- Sistema de cadastro de cardápios para agrupar items.
- Criação de pedidos.
- Interface estilizada com Tailwind CSS.

## Principais Tecnologias Utilizadas
- **Ruby**: 3.3.4
- **Rails**: 7.1.4.1
- **SQlite3**: 1.4
- **Devise**: 4.9" para autenticação de usuários
- **Tailwind CSS**: para estilização do frontend
- **Rspec Rails**: 3.13.2
- **Capybara**: 3.40.0
- **Cuprite**: 0.15.1 para testes usando javascript

## Screenshots
![Signup Page](./screenshots/signup-page.jpg "Signup")

* Para ver mais Screenshots das telas do sistema:
[Clique aqui](./screenshots)


## Configuração do Projeto
Para visualizar o projeto em seu computador, siga as instruções abaixo:

1. Clone o repositório e acesse o projeto:
```bash
git https://github.com/WillianDDaniel/take-away.git
cd take-away
```

2. Instale as dependências:
```bash
bundle install
```

3. Configure o banco de dados:
```bash
rails db:migrate
```

4. Insira dados de exemplo (opcional):

Existe um arquivo SEED no projeto que trás alguns dados fictícios para melhor visualização do projeto.
```bash
rails db:seed
```

5. Inicie o servidor:
```bash
bin/dev
```

## Testes e Qualidade de código

O Sistema foi todo construído utilizando o fluxo de TDD.
Então naturalmente temos testes automatizados para cada funcionalidade que o sistema possuí.

* Para rodar a bateria de testes execute o comando:
```bash
rspec
```

### Dependências de testes

Alguns testes precisam que o javascript da página esteja funcionando no momento de sua execução,
então para resolver esse problema, foi instalado a gem [cuprite](https://github.com/rubycdp/cuprite) pra lidar com as essas dependências e rodar os testes de navegador em segundo plano.

Siga as instruções abaixo para configurar os testes do projeto.

**No Linux/Ubunto-WSL**

Utilizando a Wget para obter o Google Chrome

1. Atualize o apt e baixe a Wget:
```bash
sudo apt update
sudo apt install -y wget
```

2. Baixe o pacote do Google Chrome:
```bash
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
```

3. Instale o Google Chrome:
```bash
sudo apt install -y ./google-chrome-stable_current_amd64.deb
```

## Endpoints da API de Pedidos

Este projeto possui rotas para consumo de informações sobre os pedidos do restaurante.
Além de um projeto Front-End em Vue.js. O [PaLevá (Gestão de Cozinha)](https://github.com/WillianDDaniel/take-away-kitchen-app) já está configurado para consumir os dados desses endpoints.

Acesse o projeto Front-End => [Clicando aqui](https://github.com/WillianDDaniel/take-away-kitchen-app)


### Listar Pedidos
```bash
GET /api/v1/restaurants/{restaurant_code}/orders
# Pârametros opcionais: status (pending, preparing, ready, delivered, cancelled)
### Listar Pedidos
```

### Detalhes de um Pedido
```bash
GET /api/v1/restaurants/{restaurant_code}/orders/{order_code}
```

### Update de status do Pedido
Este endpoint possui ações diferentes dependendo do status atual do pedido.

```bash
PUT /api/v1/restaurants/{restaurant_code}/orders/{order_code}
# Altera o status de pending para preparing, e de preparing para ready
```

### Cancelamento de Pedidos
Permite que a cozinha cancele um pedido.

```bash
PUT /api/v1/restaurants/{restaurant_code}/orders/{order_code}/cancel
# Requer parâmetro cancel_reason no corpo da requisição
```

### Exemplos de Resposta

```json
# detalhes de um pedido
{
    "code": "JETNTHKT",
    "customer_name": "João Santos",
    "created_at": "2024-11-18T03:39:52.552Z",
    "status": "pending",
    "items": [
        {
            "name": "Feijoada Completa",
            "description": "Individual",
            "price": 4200,
            "quantity": 2,
            "note": null
        }
    ],
    "cancel_reason": null,
    "total_price": 13800
}

# lista de pedidos
[
  {
    "id": 1,
    "code": "JETNTHKT",
    "customer_name": "User Name",
    "customer_phone": "11999990000",
    "customer_email": "user@email.com",
    "customer_doc": "22299977711",
    "created_at": "2024-11-18T03:39:52.552Z",
    "status": "pending",
    "menu_id": 2,
    "cancel_reason": null
  },
  {
    # Another User ...
  }
]
```

## Autor
Desenvolvido por [Willian Deiviti Daniel](https://willianddaniel.github.io/portfolio/)

