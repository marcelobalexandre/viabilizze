# language: pt

Funcionalidade: Alterar Empreendimento
  Para que possa corrigir dados de um empreendimento
  como um usuário
  eu quero poder alterar um empreendimento

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos cadastrados
    E que existem empreendimentos de outros usuários cadastrados

  Cenário: Usuário altera empreendimento próprio
    Ao alterar dados de um empreendimento próprio o usuário deve receber
    uma mensagem de empreendimento atualizado com sucesso e deve visualizar o empreendimento.

    Quando altero dados de um empreendimento próprio
    Então devo ver uma mensagem de empreendimento atualizado com sucesso
    E devo visualizar o empreendimento atualizado

  Cenário: Usuário altera empreendimento de outro usuário
    Ao abrir um empreendimento de outro usuário para alteração o usuário deve receber
    uma mensagem de acesso restrito.

    Quando abro um empreendimento de outro usuário para edição
    Então devo ver uma mensagem de acesso restrito