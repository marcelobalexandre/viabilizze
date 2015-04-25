# language: pt

Funcionalidade: Criar Múltiplas Unidades
  Para que eu possa cadastrar novas unidades rapidamente
  como um usuário
  eu quero poder criar múltiplas unidade de uma só vez

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos cadastrados

  Cenário: Usuário cria múltiplas unidades com dados válidos
    Ao criar múltiplas unidades com dados válidos o usuário deve receber
    uma mensagem de múltiplas unidades criadas com sucesso e deve visualizar o empreendimento 
    com as novas unidades.

    Quando crio múltiplas unidades com dados válidos
    Então devo ver uma mensagem de múltiplas unidades adicionadas com sucesso
    E devo visualizar o empreendimento com as novas unidades

  Cenário: Usuário cria múltiplas unidades sem nome
    Ao tentar criar múltiplas unidades sem nome o usuário deve receber
    uma mensagem de nome ausente.

    Quando crio múltiplas unidades sem nome
    Então devo ver uma mensagem de nome para múltiplas unidades ausente

  Cenário: Usuário tenta criar múltiplas unidades para empreendimento de outro usuário
    Ao tentar criar múltiplas unidades para empreendimento de outro usuário
    deve receber uma mensagem de acesso restrito.

    Dado que existem empreendimentos de outros usuários cadastrados
    Quando tento criar múltiplas unidades para empreendimento de outro usuário
    Então devo ver uma mensagem de acesso restrito