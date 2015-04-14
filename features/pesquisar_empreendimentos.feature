# language: pt

Funcionalidade: Pesquisar Empreendimentos
  Para que possa encontrar um empreendimento
  como um usuário
  eu quero poder pesquisar meus empreendimentos

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos cadastrados
    E que existem empreendimentos de outros usuários cadastrados

  Cenário: Usuário pesquisa pelo nome de um empreendimento cadastrado
    Ao abrir sua página de empreendimentos e pesquisar pelo nome de um empreendimento cadastrado
    o usuário deve visualizar o empreendimento pesquisado e não visualizar os empreendimento
    não pesquisados

    Quando abrir minha lista de empreendimentos
    E pesquisar pelo nome de um empreendimento cadastrado
    Então devo visualizar o empreendimento pesquisado
    E não devo visualizar os empreendimentos não pesquisados

  Cenário: Usuário pesquisa pelo nome de um empreendimento não cadastrado
    Ao abrir sua página de empreendimentos e pesquisar pelo nome de um empreendimento não cadastrado
    o usuário não deve visualizar nenhum empreendimento.

    Quando abrir minha lista de empreendimentos
    E pesquisar pelo nome de um empreendimento não cadastrado
    Então não devo visualizar meus empreendimentos
    E devo visualizar uma informação de que não foram encontrados empreendimentos
    E devo visualizar o campo e o botão de pesquisa

  Cenário: Usuário pesquisa com o campo em branco
    Ao abrir sua página de empreendimentos e pesquisar com o campo em branco
    o usuário deve visualizar todos os seus empreendimentos

    Quando abrir minha lista de empreendimentos
    E pesquisar com o campo em branco
    Então devo visualizar meus empreendimentos