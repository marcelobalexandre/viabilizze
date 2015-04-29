# language: pt

Funcionalidade: Alterar Análise de Sensibilidade
  Para que possa corrigir dados de uma análise de sensibilidade
  como um usuário
  eu quero poder alterar uma análise de sensibilidade

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos com análises de sensibilidade cadastrados
    E que existem empreendimentos com análises de sensibilidade de outros usuários cadastrados

  Cenário: Usuário altera análise de sensibilidade própria
    Ao alterar dados de uma análise de sensibilidade própria o usuário deve receber
    uma mensagem de análise de sensibilidade atualizada com sucesso e deve visualizar
    a análise de sensibilidade.

    Quando altero dados de uma análise de sensibilidade própria
    Então devo ver uma mensagem de análise de sensibilidade atualizada com sucesso
    E devo visualizar a análise de sensibilidade atualizada

  Cenário: Usuário altera análise de sensibilidade de outro usuário
    Ao abrir uma análise de sensibilidade de outro usuário para alteração o usuário deve receber
    uma mensagem de acesso restrito.

    Quando abro uma análise de sensibilidade de outro usuário para edição
    Então devo ver uma mensagem de acesso restrito