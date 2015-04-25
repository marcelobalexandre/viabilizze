# language: pt

Funcionalidade: Excluir Unidade
  Para que possa excluir uma unidade incorreta
  como um usuário
  eu quero poder excluir uma unidade

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos com unidades cadastrados

  Cenário: Usuário excluir unidade própria
    Ao excluir uma unidade própria o usuário deve receber
    uma mensagem de unidade excluída com sucesso.

    Quando excluo uma unidade própria
    Então devo ver uma mensagem de unidade excluída com sucesso