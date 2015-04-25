# language: pt

Funcionalidade: Alterar Unidade
  Para que possa corrigir dados de uma unidade
  como um usuário
  eu quero poder alterar uma unidade

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos com unidades cadastrados
    E que existem empreendimentos com unidades de outros usuários cadastrados

  Cenário: Usuário altera unidade própria
    Ao alterar dados de uma unidade própria o usuário deve receber
    uma mensagem de unidade atualizada com sucesso e deve visualizar a unidade.

    Quando altero dados de uma unidade própria
    Então devo ver uma mensagem de unidade atualizada com sucesso
    E devo visualizar a unidade atualizada

  Cenário: Usuário altera unidade de outro usuário
    Ao abrir uma unidade de outro usuário para alteração o usuário deve receber
    uma mensagem de acesso restrito.

    Quando abro uma unidade de outro usuário para edição
    Então devo ver uma mensagem de acesso restrito