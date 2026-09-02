# Projeto-ODS9 Amazônia 
Amazônia Inteligente

Plataforma Inteligente de Monitoramento de Infraestrutura e Serviços Essenciais em Comunidades Isoladas da Amazônia

# 2. ODS Escolhido

### ODS 9 — Indústria, Inovação e Infraestrutura

O Amazônia Inteligente está diretamente relacionado ao ODS 9, que busca promover infraestrutura resiliente, inovação e desenvolvimento sustentável. O projeto utiliza tecnologia e Inteligência Artificial para monitorar seis áreas essenciais — conectividade, energia, saneamento, saúde, educação e meio ambiente, permitindo identificar padrões, antecipar possíveis problemas e gerar alertas para quem pode agir.

Em comunidades isoladas da Amazônia, onde informações sobre problemas de infraestrutura muitas vezes chegam tarde, a plataforma funciona como uma ferramenta de infraestrutura social, conectando dados, comunidades e responsáveis para tornar a resposta aos problemas mais rápida e eficiente.

# 3. Problema Real

As comunidades isoladas da Amazônia enfrentam dificuldades para ter acesso regular a serviços essenciais, como energia elétrica, internet, água potável, saneamento e transporte. Essas dificuldades estão relacionadas principalmente às grandes distâncias, à dispersão das comunidades e às características geográficas da região, que tornam a instalação e a manutenção de infraestrutura mais complexas.

Esse problema ainda afeta uma quantidade significativa de pessoas. Segundo a Empresa de Pesquisa Energética (EPE), o planejamento de 2025 para os Sistemas Isolados considera o atendimento de quase 2 milhões de pessoas distribuídas em 160 localidades isoladas, demonstrando a dimensão do desafio de garantir um fornecimento adequado de energia nessas regiões.
A dificuldade também aparece no acesso ao saneamento. Dados do IBGE mostram que, entre moradores de Territórios Quilombolas localizados na Amazônia Legal, 96,9% convivem com algum tipo de precariedade relacionada ao abastecimento de água, ao esgotamento sanitário ou à coleta de lixo.

Além disso, estudos sobre comunidades ribeirinhas mostram que o isolamento geográfico interfere diretamente no acesso a serviços. Em determinadas comunidades, moradores podem precisar realizar deslocamentos de muitas horas para chegar aos centros urbanos, enquanto o acesso à internet também pode ser limitado ou instável.
Dessa forma, o problema não é apenas a falta de infraestrutura, mas também a dificuldade de acompanhar a situação dessas comunidades e identificar rapidamente quais áreas precisam de atenção.

# 4. Solução com Inteligência Artificial

### Como a Inteligência Artificial será utilizada:

 A Inteligência Artificial vai ser usada no Amazônia Inteligente pra analisar os dados coletados nas comunidades isoladas da região. A ideia é treinar nosso próprio modelo de Machine Learning, usando dados simulados baseados na realidade de Santa Rosa do Purus (AC), em vez de depender de alguma IA pronta de terceiro.

Ela vai acompanhar informações de energia, internet, saneamento, saúde, educação e meio ambiente, e a partir desses dados consegue identificar quando algo sai do normal, gerando um alerta automaticamente. Por exemplo: se uma comunidade tiver problema no fornecimento de energia, o sistema gera um alerta avisando que o nível está abaixo do recomendado. Ou, na área da saúde, se a IA perceber um aumento fora do padrão nos casos registrados, ela pode gerar um alerta indicando que aquilo precisa de acompanhamento.

No fim, a função principal da IA é identificar problema rápido e de forma automática, avisando os responsáveis e facilitando a tomada de decisão — sem precisar que alguém fique analisando todos os dados manualmente.

# 5. Público-Alvo

1. ### Morador da comunidade:
   
    utiliza o app para acompanhar o que está acontecendo na própria região e sinalizar problemas do dia a dia, como falta de água, energia ou conectividade.

3. ### Agente local:

    como agentes de saúde ou agentes comunitários, utiliza o app para registrar informações coletadas em campo, atualizar a situação da comunidade e acompanhar possíveis problemas.

5. ### Gestor público:

   acompanha indicadores das comunidades, recebe alertas sobre situações críticas e utiliza os dados para identificar prioridades e direcionar ações e recursos.

7. ### Equipes de manutenção:

   recebem ocorrências e podem acompanhar quais problemas precisam de atendimento e em quais locais.

 
# 6. Áreas Monitoradas

### 🛜 Conectividade

### ⚡ Energia

### 🚰 Saneamento

### 🚑 Saúde 

### 🎓 Educação

### 🌱 Meio Ambiente

# 7. Modelagem Inicial — POO

Usuário: Pessoa que utiliza o aplicativo.


Comunidade: Região monitorada pelo sistema.


Área Monitorada: representa uma das 6 frentes de acompanhamento "(Conectividade, Energia, Saneamento, Saúde, Educação, Meio Ambiente)"


Sensor: Fonte de dados sobre faltade energia, conectividade, saneamento ou meio ambiente.


Alerta: Aviso sobre uma situações classificadas como normal, atenção e critico


Relatório: Registro das condições e ocorrências identificadas pelo sistema.

# 7.1 Diagrama de Classes

...

# 8. Tecnologias

### 1️⃣ Front-end (Aplicativo Móvel):

Flutter + Dart - será utilizado para desenvolver o aplicativo móvel, permitindo que a mesma base de código seja utilizada para Android e iOS. O aplicativo apresentará aos moradores informações sobre conectividade, energia, saneamento, logística, educação e meio ambiente, além de exibir os níveis de situação Normal, Atenção e Crítico e receber notificações de alertas.

### 2️⃣ Back-end / API:

Python + FastAPI - será utilizado para desenvolver a API responsável pela comunicação entre o aplicativo, o banco de dados, a Inteligência Artificial e os dados de monitoramento. A API receberá os dados dos diferentes segmentos, processará as informações necessárias e disponibilizará os resultados para o aplicativo.

### 3️⃣ Banco de Dados:

Firebase Firestore - será utilizado para armazenar as informações do sistema, como dados das comunidades, usuários, registros de monitoramento, ocorrências e alertas. O banco permitirá que as informações sejam consultadas e atualizadas pelo sistema de forma integrada ao aplicativo.

### 4️⃣ Inteligência Artificial:

Python + Scikit-learn + Pandas — modelo próprio de Machine Learning, treinado com dados simulados baseados na realidade de Santa Rosa do Purus (AC)

### 5️⃣ Coleta de Dados (Sensores):

Os dados de sensores (energia, água, conectividade etc.) serão simulados, tendo como referência a realidade de Santa Rosa do Purus (AC), sem necessidade de hardware físico nesta etapa do projeto

### 6️⃣ Gestão do Projeto:

GitHub (repositório, Issues e Projects/Kanban) - utilizado para armazenar o código e organizar tarefas através de Issues e Kanban.

# 9. Arquitetura do Sistema

Será desenvolvida em uma etapa posterior do projeto.

# 10. Organização da Equipe

 Integrante Responsabilidade Frente 

 Diego A. Oliveira RA: 926118900 - Kanban/Issues, Organização da Equipe  GitHub/Gestão 
 
 Nome 2  Problema Real  Visão
 
 Solução com IA  Visão
 
 Nome 4  Público-Alvo / ODS  Visão 
 
 Nome 5  Entidades principais  POO 
 
 Nome 6  Atributos/métodos (parte 1)  POO 
 
 Nome 7  Atributos/métodos (parte 2) + relações  POO 
 
 Nome 8  Diagrama de Classes  POO 
 
 Nome 9  Tecnologias  GitHub/Gestão 
 
 Nome 10  — (reserva/ajuda geral)

# 11. Gestão do Projeto

O projeto será gerenciado utilizando GitHub Projects (Kanban) e Issues

- Fazer : tarefas planejadas, ainda não iniciadas
- Em Progreso : em desenvolvimento
- Análise : aguardando revisão de outro membro antes de mesclar
- Feito : concluído e mesclado na main

Cada tarefa do projeto corresponde a uma Issue no GitHub, atribuída a um responsável. 
As entregas quinzenais são acompanhadas movendo os cartões entre as colunas conforme o progresso.


# 12. Desafios e Sustentabilidade

Por se tratar de uma solução voltada a comunidades isoladas e com baixo orçamento disponível, o projeto considera desde já os principais desafios que podem surgir ao longo do desenvolvimento e operação, junto com soluções viáveis e de baixo custo para cada um.

### Infraestrutura e Conectividade

Desafio: conexão intermitente ou inexistente na maior parte do tempo.

Solução: modo offline-first — o app funciona localmente (dados salvos no próprio celular) e sincroniza automaticamente assim que houver conexão disponível, mesmo que por poucos minutos.

Desafio: falta de energia para carregar os dispositivos que rodam o app.

Solução: otimização do app para baixo consumo de bateria, reduzindo notificações constantes e priorizando sincronização em lote.

### Sustentabilidade Financeira

Desafio: custo de manter servidor, manutenção e atualizações após o encerramento do projeto acadêmico.

Solução: uso de serviços com camada gratuita para prototipagem (ex: Firebase, Supabase), com possibilidade futura de financiamento público ou parcerias com ONGs.

Desafio: custo de uso contínuo de APIs de IA pagas.

Solução: priorização de modelos de IA open-source e gratuitos, reservando serviços pagos apenas para funcionalidades essenciais.

### Adoção e Capacitação Local

Desafio: baixa familiaridade da população com aplicativos digitais.

Solução: interface simples, com ícones grandes e pouco texto, além de parceria com agentes locais (como agentes de saúde) já confiáveis na comunidade.

Desafio: ausência de suporte técnico local em caso de falhas.

Solução: documentação simples e visual, com capacitação básica de pontos focais em cada comunidade.

### Institucional e Político

Desafio: dependência de continuidade por parte de gestões públicas.

Solução: manutenção do projeto como open-source, documentado publicamente, permitindo que universidades, ONGs ou futuras gestões deem continuidade sem depender de uma única entidade.

### Qualidade e Confiabilidade dos Dados

Desafio: imprecisão em dados simulados ou reportados manualmente, e possível desengajamento dos moradores ao longo do tempo.

Solução: simplificação máxima do processo de reporte (poucos toques) e uso de regras transparentes antes de evoluir para modelos de IA mais complexos.

### Ambiental e Geográfico

Desafio: eventos climáticos extremos podem isolar ainda mais a comunidade justamente quando o sistema seria mais necessário.

Solução: garantir que alertas críticos funcionem mesmo com conectividade mínima, com SMS como alternativa ao uso do app.
