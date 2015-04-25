# language: pt

Funcionalidade: Excluir Empreendimento
  Para que possa excluir um empreendimento incorreto
  como um usuário
  eu quero poder excluir um empreendimento

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos cadastrados

  Cenário: Usuário exclui empreendimento próprio
    Ao excluir um empreendimento próprio o usuário deve receber
    uma mensagem de empreendimento excluído com sucesso.

    Quando excluo um empreendimento próprio
    Então devo ver uma mensagem de empreendimento excluído com sucesso