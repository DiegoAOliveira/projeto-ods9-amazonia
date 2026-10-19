# 🗄️ Diagrama MER — Banco de Dados

Este diagrama representa a estrutura do banco de dados do sistema, apresentando
as entidades, seus principais atributos, chaves primárias (PK), chaves
estrangeiras (FK) e os relacionamentos existentes entre elas.

```mermaid
erDiagram

    USUARIO {
        int id_usuario PK
        string nome
        string email
        string senha
        string tipo
    }

    COMUNIDADE {
        int id_comunidade PK
        string nome
        string descricao
    }

    LOCALIZACAO {
        int id_localizacao PK
        string cidade
        string bairro
        string endereco
        int id_comunidade FK
    }

    AREA_MONITORADA {
        int id_area PK
        string nome
        string descricao
        int id_localizacao FK
    }

    SENSOR {
        int id_sensor PK
        string tipo
        float valor_atual
        datetime data_atualizacao
        int id_area FK
    }

    STATUS {
        int id_status PK
        string situacao
        datetime data_hora
        int id_sensor FK
    }

    ALERTA {
        int id_alerta PK
        string mensagem
        datetime data_hora
        int id_usuario FK
        int id_sensor FK
    }

    RELATORIO {
        int id_relatorio PK
        datetime data_geracao
        string descricao
        int id_usuario FK
        int id_area FK
    }

    MODELO_PREDITIVO {
        int id_modelo PK
        string resultado
        datetime data_analise
        int id_sensor FK
    }


    COMUNIDADE ||--o{ LOCALIZACAO : "possui"

    LOCALIZACAO ||--o{ AREA_MONITORADA : "define"

    AREA_MONITORADA ||--o{ SENSOR : "possui"

    SENSOR ||--o{ STATUS : "registra"

    SENSOR ||--o{ ALERTA : "gera"

    SENSOR ||--o{ MODELO_PREDITIVO : "fornece dados"

    USUARIO ||--o{ ALERTA : "recebe"

    USUARIO ||--o{ RELATORIO : "gera"

    AREA_MONITORADA ||--o{ RELATORIO : "compõe"
```
