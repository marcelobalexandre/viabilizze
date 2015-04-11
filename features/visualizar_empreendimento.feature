# language: pt

Funcionalidade: Visualizar Empreendimento
  Para que possa visualizar os dados de um um empreendimento
  como um usuário
  eu quero poder visualizar um empreendimento

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos cadastrados
    E que existem empreendimentos de outros usuários cadastrados

  Cenário: Usuário acessa página de um empreendimento próprio
    Ao abrir a página de um empreendimento próprio o usuário
    deve visualizar seu empreendimento.

    Quando abrir um empreendimento próprio
    Então devo visualizar meu empreendimento

  Cenário: Usuário acessa página de um empreendimento de outro usuário
    Ao abrir a página de um empreendimento de outro usuário o usuário
    deve visualizar uma mensagem de acesso restrito.

    Quando abrir um empreendimento de outro usuário
    Então devo ver uma mensagem de acesso restrito

  Cenário: Usuário não conectado acessa página de um empreendimento de um usuário
    Ao abrir a página de um empreendimento de um usuário o usuário não conectado
    deve visualizar uma mensagem de que é necessário se conectar.

    Dado que não estou conectado ao site
    Quando abrir um empreendimento de outro usuário
    Então devo ver uma mensagem de que é necessário se conectar