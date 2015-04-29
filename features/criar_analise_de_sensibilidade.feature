# language: pt

Funcionalidade: Criar Análise de Viabilidade
  Para que eu possa realizar a análise de viabilidade de um empreendimento
  como um usuário
  eu quero poder criar uma análise de sensibilidade de um empreendimento

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos cadastrados

  Cenário: Usuário cria análise de sensibilidade com dados válidos
    Ao criar uma análise de sensibilidade com dados válidos o usuário deve receber
    uma mensagem de análise de sensibilidade criada com sucesso e deve visualizar a
    análise de sensibildiade.

    Quando crio uma análise de sensibilidade com dados válidos
    Então devo ver uma mensagem de análise de sensibilidade adicionada com sucesso
    E devo visualizar a análise de sensibilidade

  Cenário: Usuário cria análise de sensibilidade sem nome
    Ao criar uma análise de sensibilidade sem nome o usuário deve receber
    uma mensagem de nome ausente.

    Quando crio uma análise de sensibilidade sem nome
    Então devo ver uma mensagem de nome da análise de sensibilidade ausente

  Cenário: Usuário tenta criar análise de sensibilidade para empreendimento de outro usuário
    Ao tentar criar uma análise de sensibilidade para empreendimento de outro usuário
    deve receber uma mensagem de acesso restrito.

    Dado que existem empreendimentos de outros usuários cadastrados
    Quando tento criar uma análise de sensibilidade para empreendimento de outro usuário
    Então devo ver uma mensagem de acesso restrito