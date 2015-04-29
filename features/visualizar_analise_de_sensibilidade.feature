# language: pt

Funcionalidade: Visualizar Análise de Sensibilidade
  Para que possa visualizar os dados de uma análise de sensibildiade
  como um usuário
  eu quero poder visualizar uma análise de sensibilidade

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos com análises de sensibilidade cadastrados
    E que existem empreendimentos com análises de sensibilidade de outros usuários cadastrados

  Cenário: Usuário acessa página de uma análise de sensibilidade própria
    Ao abrir a página de uma análise de sensibilidade própria o usuário
    deve visualizar sua análise de sensibilidade.

    Quando abrir uma análise de sensibilidade própria
    Então devo visualizar minha análise de sensibilidade

  Cenário: Usuário acessa página de uma análise de sensibilidade de outro usuário
    Ao abrir a página de uma análise de sensibilidade de outro usuário o usuário
    deve visualizar uma mensagem de acesso restrito.

    Quando abrir uma análise de sensibilidade de outro usuário
    Então devo ver uma mensagem de acesso restrito

  Cenário: Usuário não conectado acessa análise de sensibilidade de um usuário
    Ao abrir a página de uma análise de sensibilidade de um usuário o usuário não conectado
    deve visualizar uma mensagem de que é necessário se conectar.

    Dado que não estou conectado ao site
    Quando abrir uma análise de sensibilidade de outro usuário
    Então devo ver uma mensagem de que é necessário se conectar