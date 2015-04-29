# language: pt

Funcionalidade: Excluir Análise de Sensibilidade
  Para que possa excluir uma análise de sensibilidade incorreta
  como um usuário
  eu quero poder excluir uma análise de sensibilidade

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos com análises de sensibilidade cadastrados

  Cenário: Usuário exclui análise de sensibilidade própria
    Ao excluir uma análise de sensibilidade própria o usuário deve receber
    uma mensagem de análise de sensibilidade excluída com sucesso.

    Quando excluo uma análise de sensibilidade própria
    Então devo ver uma mensagem de análise de sensibilidade excluída com sucesso