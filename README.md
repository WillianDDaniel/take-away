# Projeto PaLevá (Take Away)

Projeto em desenvolvimento para o sistema **PaLevá (Take Away)**, um aplicativo web para gerenciamento de cardápio de um restaurante, permitindo que os proprietários de restaurantes cadastrem pratos e gerenciem o cardápio de forma prática e organizada.


## Principais Tecnologias Utilizadas
- **Ruby**: 3.3.4
- **Rails**: 7.1.4.1
- **Tailwind CSS**: para estilização do frontend
- **Rspec Rails**: 3.13.2
- **Capybara**: 3.40.0
- **Cuprite**: 0.15.1 para testes usando javascript


## Funcionalidades
- Registro e gerenciamento de pratos com características como "vegetariano", "vegano", "sem glúten", entre outros.
- Cadastro de preços e histórico de preços para acompanhar alterações.
- Organização e filtragem de pratos por características e tags.
- Interface estilizada com Tailwind CSS.

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

Existe um arquivo SEED no projeto que trás alguns dados fictícios para melhor visualização do projetos.
```bash
rails db:seed
```

5. Inicie o servidor:
```bash
rails server
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
