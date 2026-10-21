## 🗄️ Modelo Entidade-Relacionamento (MER)

O Modelo Entidade-Relacionamento (MER) do **Amazônia Inteligente** representa a estrutura do banco de dados desenvolvido para organizar as informações relacionadas ao monitoramento de áreas e serviços essenciais nas comunidades de Santa Rosa do Purus – AC.

O modelo foi desenvolvido com o objetivo de estruturar os dados de maneira organizada, estabelecer relacionamentos entre as entidades e facilitar o armazenamento, a consulta e a análise das informações utilizadas pelo sistema.

### 📌 Entidades do sistema

O banco de dados é composto por oito entidades principais:

- **Usuario:** armazena os dados dos usuários cadastrados, incluindo nome, e-mail, senha e perfil de acesso.
- **Comunidade:** registra as comunidades monitoradas, sua localização e a população estimada.
- **Area Monitorada:** representa as áreas acompanhadas pelo sistema, permitindo identificar seu tipo e status atual.
- **Sensor:** armazena registros de monitoramento, incluindo tipo, localização, valores medidos, origem dos dados e status.
- **Alerta:** registra ocorrências identificadas pelo sistema, classificando-as por tipo, gravidade e status.
- **Analise IA:** armazena os prompts e as respostas das análises realizadas por inteligência artificial, vinculando-as aos registros analisados e aos alertas relacionados.
- **Relatorio:** organiza informações consolidadas para geração de relatórios e acompanhamento dos indicadores do sistema.
- **Modelo Preditivo:** representa os modelos utilizados em futuras análises preditivas, incluindo versão, acurácia e data de treinamento.

### 🔗 Relacionamentos

O modelo estabelece relacionamentos entre as entidades por meio de chaves primárias e estrangeiras, garantindo a integridade referencial dos dados.

Entre os principais relacionamentos estão:

- Uma comunidade pode possuir várias áreas monitoradas.
- Uma área monitorada pode estar associada a vários registros de sensores.
- Um usuário pode ser responsável pelo registro de dados e pelo recebimento de alertas.
- Um sensor pode estar relacionado a diferentes alertas e análises de inteligência artificial.
- Uma análise de IA pode estar vinculada a um alerta gerado.
- Uma área monitorada pode estar associada a modelos preditivos.

### 🛠️ Tecnologias utilizadas

- **MySQL:** sistema gerenciador do banco de dados relacional.
- **SQL:** linguagem utilizada para criação das tabelas, definição dos relacionamentos e manipulação dos dados.
- **dbdiagram.io:** ferramenta utilizada para representar visualmente o modelo e facilitar a compreensão da estrutura do banco.

### 🎯 Objetivo do modelo

O MER serve como base para a organização dos dados do Amazônia Inteligente, contribuindo para a rastreabilidade das ocorrências, o acompanhamento das áreas monitoradas e a futura integração com recursos de inteligência artificial e análise preditiva.

O modelo poderá evoluir conforme o desenvolvimento do projeto e a implementação de novas funcionalidades.

---

### 📊 Diagrama do banco de dados

![Diagrama MER do Amazônia Inteligente](MER-Amazonia-Inteligente.png)

