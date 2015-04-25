# language: pt

Funcionalidade: Visualizar Unidade
  Para que possa visualizar os dados de uma unidade
  como um usuário
  eu quero poder visualizar uma unidade

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos com unidades cadastrados
    E que existem empreendimentos com unidades de outros usuários cadastrados

  Cenário: Usuário acessa página de uma unidade própria
    Ao abrir a página de uma unidade própria o usuário
    deve visualizar sua unidade.

    Quando abrir uma unidade própria
    Então devo visualizar minha unidade

  Cenário: Usuário acessa página de uma unidade de outro usuário
    Ao abrir a página de uma unidade de outro usuário o usuário
    deve visualizar uma mensagem de acesso restrito.

    Quando abrir uma unidade de outro usuário
    Então devo ver uma mensagem de acesso restrito

  Cenário: Usuário não conectado acessa página de uma unidade de um usuário
    Ao abrir a página de uma unidade de um usuário o usuário não conectado
    deve visualizar uma mensagem de que é necessário se conectar.

    Dado que não estou conectado ao site
    Quando abrir uma unidade de outro usuário
    Então devo ver uma mensagem de que é necessário se conectar