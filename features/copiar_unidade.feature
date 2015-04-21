# language: pt

Funcionalidade: Copiar Unidade
  Para que eu possa cadastrar novas unidades rapidamente
  como um usuário
  eu quero poder copiar os dados de uma unidade existente em um empreendimento

  Contexto:
    Dado que estou conectado
    E que tenho empreendimentos com unidades cadastrados

  Cenário: Usuário copia dados de uma unidade existente
    Ao clicar no botão copiar na tela de cadastro de unidades o usuário deve visualizar
    outras unidades do empreendimento. Ao selecionar uma unidade os dados devem
    ser copiados para a unidade que está sendo cadastrada.

    Quando acesso um empreendimento próprio
    E clico em Adicionar Unidade
    E clico em Copiar Unidade
    E clico em uma unidade existente
    Então devo ver os dados da unidade selecionada nos campos da unidade sendo cadastrada