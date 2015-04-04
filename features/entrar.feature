# language: pt

Funcionalidade: Entrar
  Para que possa usar o aplicativo
  como um usuário
  eu quero poder entrar com minha conta

  Cenário: Usuário não cadastrado
    Ao se conectar com credencias válidas mas não existentes o usuário
    deve permanecer desconectado e receber uma mensagem de conexão inválida.

    Dado que não estou cadastrado
    Quando me conectar com e-mail e senha válidos
    Então devo ver uma mensagem de conexão inválida
    E devo estar desconectado

  Cenário: Usuário se conecta com e-mail e senha com sucesso
    Ao se conectar com e-mail e senha válidos e existentes o usuário
    deve ser conectado e receber uma mensagem de conexão realizada com sucesso.

    Dado que estou cadastrado
    E que não estou conectado ao site
    Quando me conectar com e-mail e senha válidos
    Então devo ver uma mensagem de conexão realizada com sucesso
    E devo estar conectado

  Cenário: Usuário digita um e-mail incorreto
    Ao se conectar com um e-mail incorreto o usuário deve
    permanecer desconectado e receber uma mensagem de conexão inválida.

    Dado que estou cadastrado
    E que não estou conectado ao site
    Quando me conectar com um e-mail incorreto
    Então devo ver uma mensagem de conexão inválida
    E devo estar desconectado

  Cenário: Usuário digita uma senha incorreta
    Ao se conectar com uma senha incorreta o usuário deve
    permanecer desconectado e receber uma mensagem de conexão inválida.

    Dado que estou cadastrado
    E que não estou conectado ao site
    Quando me conectar com uma senha incorreta
    Então devo ver uma mensagem de conexão inválida
    E devo estar desconectado