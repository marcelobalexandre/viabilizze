# language: pt

Funcionalidade: Criar Conta
  Para que possa acessar o aplicativo
  como um usuário
  eu quero poder criar uma conta

  Contexto:
    Dado que não estou conectado ao site

  Cenário: Usuário se inscreve com dados válidos
    Ao se inscrever com dados válidos o usuário deve receber
    uma mensagem de boas vindas.

    Quando me inscrevo com dados válidos
    Então devo ver uma mensagem de conta criada com sucesso

  Cenário: Usuário se inscreve sem nome
    Ao se inscrever sem um nome o usuário deve receber
    uma mensagem de nome ausente.

    Quando me inscrevo sem um nome
    Entao devo ver uma mensagem de nome ausente

  Cenário: Usuário se inscreve com e-mail inválido
    Ao se inscrever com um e-mail inválido o usuário deve receber
    uma mensagem de e-mail inválido.

    Quando me inscrevo com um e-mail inválido
    Entao devo ver uma mensagem de e-mail inválido

  Cenário: Usuário se inscreve sem senha
    Ao se inscrever sem uma senha o usuário deve receber
    uma mensagem de senha ausente.

    Quando me inscrevo sem uma senha
    Entao devo ver uma mensagem de senha ausente

  Cenário: Usuário se inscreve com confirmação da senha diferente da senha
    Ao se inscrever com a confirmação da senha diferente da senha
    o usuário deve receber uma mensagem de confirmação de senha incorreta.

    Quando me inscrevo com a confirmação da senha diferente da senha
    Entao devo ver uma mensagem de confirmação incorreta