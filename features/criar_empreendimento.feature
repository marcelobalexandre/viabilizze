# language: pt

Funcionalidade: Criar Empreendimento
  Para que eu possa realizar a análise de viabilidade de um empreendimento
  como um usuário
  eu quero poder criar um empreendimento

  Contexto:
    Dado que estou conectado

  Cenário: Usuário cria empreendimento com dados válidos
    Ao criar um empreendimento com dados válidos o usuário deve receber
    uma mensagem de empreendimento criado com sucesso e deve visualizar o empreendimento.

    Quando crio um empreendimento com dados válidos
    Então devo ver uma mensagem de empreendimento criado com sucesso
    E devo visualizar o empreendimento

  Cenário: Usuário cria empreendimento sem nome
    Ao criar um empreendimento sem nome o usuário deve receber
    uma mensagem de nome ausente.

    Quando crio um empreendimento sem nome
    Então devo ver uma mensagem de nome do empreedimento ausente

  Cenário: Usuário tenta criar empreendimento para outro usuário
    Ao tentar criar um empreendimento para outro usuário deve receber
    um mensagem de acesso restrito.

    Dado que existem empreendimentos de outros usuários cadastrados
    Quando tento criar um empreendimento para outro usuário
    Então devo ver uma mensagem de acesso restrito