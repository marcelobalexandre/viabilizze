# language: pt

Funcionalidade: Criar Unidade
  Para que eu possa realizar a análise de viabilidade de um empreendimento
  como um usuário
  eu quero poder criar uma unidade de um empreendimento

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos cadastrados

  Cenário: Usuário cria unidade com dados válidos
    Ao criar uma unidade com dados válidos o usuário deve receber
    uma mensagem de unidade criada com sucesso e deve visualizar o empreendimento 
    com a nova unidade.

    Quando crio uma unidade com dados válidos
    Então devo ver uma mensagem de unidade adicionada com sucesso
    E devo visualizar o empreendimento com a nova unidade

  Cenário: Usuário cria unidade sem nome
    Ao criar uma unidade sem nome o usuário deve receber
    uma mensagem de nome ausente.

    Quando crio uma unidade sem nome
    Então devo ver uma mensagem de nome da unidade ausente

  Cenário: Usuário tenta criar unidade para empreendimento de outro usuário
    Ao tentar criar uma unidade para empreendimento de outro usuário
    deve receber uma mensagem de acesso restrito.

    Dado que existem empreendimentos de outros usuários cadastrados
    Quando tento criar uma unidade para empreendimento de outro usuário
    Então devo ver uma mensagem de acesso restrito