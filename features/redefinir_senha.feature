# language: pt

Funcionalidade: Redefinir Senha
  Para que possa voltar a acessar o aplicativo com minha conta
  como um usuário
  eu quero poder redefinir minha senha

  Cenário: Usuário solicita reset de senha com e-mail
    Ao solicitar um reset de senha com e-mail o usuário
    deve receber um e-mail com as instrunções do reset.

    Dado que solicitei o reset da minha senha com o e-mail
    Então devo receber um e-mail com as instruções do reset.
