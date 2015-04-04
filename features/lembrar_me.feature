# language: pt

Funcionalidade: Lembrar-me
  Para não precisar digitar as credencias novamente
  como um usuário
  eu quero poder ser lembrado

  Cenário: Usuário se conecta com lembrar-me marcado e fecha o navegador e abre novamente
    Ao se conectar com lembrar-me marcado e fechar e abrir o navegador o usuário
    deve permanecer conectado.

    Dado que me conectei com lembrar-me marcado
    Quando fechar meu navegador
    E abrir meu navegador novamente
    Então devo estar conectado

  Cenário: Usuário se conecta com lembrar-me desmarcado e fecha o navegador e abre novamente
    Ao se conectar com lembrar-me desmarcado e fechar e abrir o navegador o usuário
    deve ser desconectado.

    Dado que me conectei com lembrar-me desmarcado
    Quando fechar meu navegador
    E abrir meu navegador novamente
    Então devo estar desconectado