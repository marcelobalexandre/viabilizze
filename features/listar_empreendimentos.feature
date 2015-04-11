# language: pt

Funcionalidade: Listar Empreendimentos
  Para que possa encontrar um empreendimento
  como um usuário
  eu quero poder visualizar meus empreendimentos

  Contexto:
    Dado que estou conectado
    E que existem empreendimentos de outros usuários cadastrados

  Cenário: Usuário acessa sua página de empreendimentos (sem empreendimentos)
    Ao abrir sua página de empreendimento (sem empreendimentos) o usuário
    deve visualizar um botão para adicionar novos empreendimentos

    Dado que não tenho empreendimentos cadastrados
    Quando abrir minha lista de empreendimentos
    Então devo visualizar uma informação de que não existem empreendimentos cadastrados
    E devo visualizar um botão para adicionar novos empreendimentos
    E não devo visualizar empreendimentos de outros usuários

  Cenário: Usuário acessa sua página de empreendimentos (com empreendimentos)
    Ao abrir sua página de empreendimento (com empreendimentos) o usuário
    deve visualizar seus empreendimentos

    Dado que tenho empreendimentos cadastrados
    Quando abrir minha lista de empreendimentos
    Então devo visualizar meus empreendimentos
    E não devo visualizar uma informação de que não existem empreendimentos cadastrados
    E não devo visualizar um botão para adicionar novos empreendimentos
    E não devo visualizar empreendimentos de outros usuários

  Cenário: Usuário acessa página de empreendimentos de outro usuário
    Ao abrir a lista de empreendimentos de outro usuário o usuário
    deve visualizar uma mensagem de acesso restrito.

    Quando abrir a lista de empreendimentos de outro usuário
    Então devo ver uma mensagem de acesso restrito