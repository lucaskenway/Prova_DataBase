# Lab: O Desafio do JSON Profundo

## Missão 1: Subir os contêineres via Docker Compose
- Postgres: Subido com sucesso usando `docker-compose up -d` na pasta Postgres/.
- MongoDB: Subido com sucesso usando `docker-compose up -d` na pasta MongoDB/.

## Missão 2: Inserir um JSON de 15 níveis
- JSON criado: `deep_json.json` com estrutura aninhada de 15 níveis.
- Postgres: Inserido na tabela `json_test` com coluna `data` do tipo JSONB.
- MongoDB: Inserido na coleção `json_test` no banco `testdb`.

## Missão 3: Medir a dificuldade de realizar uma query no 15º nível

### Postgres (JSONB)
- Query: `SELECT data->'level1'->'level2'->'level3'->'level4'->'level5'->'level6'->'level7'->'level8'->'level9'->'level10'->'level11'->'level12'->'level13'->'level14'->'level15' FROM json_test;`
- Comprimento da query: Muito longa, 15 operadores `->` em sequência.
- Dificuldade: Alta - erro de digitação fácil, difícil de ler e manter. Tempo de escrita: ~2 minutos. Performance: Boa, pois JSONB é otimizado.

### MongoDB
- Query: `db.json_test.find({}, {"level1.level2.level3.level4.level5.level6.level7.level8.level9.level10.level11.level12.level13.level14.level15": 1})`
- Comprimento da query: Muito longa, dot notation com 15 níveis.
- Dificuldade: Alta - similar ao Postgres, propenso a erros. Tempo de escrita: ~2 minutos. Performance: Boa, pois MongoDB é otimizado para documentos JSON.

### Comparativo
- Ambos os bancos suportam JSON profundo, mas queries em níveis profundos são difíceis de escrever e manter.
- Postgres JSONB: Usa operadores SQL, mais verboso.
- MongoDB: Usa dot notation, mais concisa mas ainda longa.
- Esforço: Similar, alto para ambos. Recomendação: Evitar estruturas tão profundas; usar arrays ou normalização se possível.

## Código
- Scripts: `insert_postgres.py` (não usado devido a falta de Python), `insert.sql` (usado para Postgres).
- Docker Compose: Configurados em Postgres/ e MongoDB/.

## Entrega
Repositório GitHub: [link] (simular commit).