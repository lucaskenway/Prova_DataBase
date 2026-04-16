# Sistema de Gestão Acadêmica - SigaEdu

## 1. SGBD Relacional

A escolha de um SGBD relacional foi adotada para garantir integridade, consistência e governança dos dados de um sistema acadêmico.

As propriedades ACID são fundamentais:

* **Atomicidade:** cada transação é executada por completo ou é totalmente revertida.
* **Consistência:** mantém os dados em um estado válido e respeita regras de integridade.
* **Isolamento:** evita que transações concorrentes tenham efeitos visíveis entre si antes da conclusão.
* **Durabilidade:** garante que os dados persistam após confirmações, mesmo após falhas.

No cenário de gestão acadêmica, o modelo relacional permite usar chaves primárias e estrangeiras para assegurar relacionamentos fortes entre alunos, disciplinas, turmas, matrículas e notas.

O modelo relacional também facilita controles de acesso, regras de DCL e integridade referencial, diferentemente de muitos bancos NoSQL.

---

## 2. Uso de Schemas

Foram criados dois schemas distintos:

* **academico:** contém as tabelas de modelo lógico, como aluno, professor, disciplina, turma, matricula e nota.
* **seguranca:** destinado a roles, usuários e objetos de governança.

Vantagens do uso de schemas:

* Separação de responsabilidades por domínio;
* Melhor organização e legibilidade do banco;
* Políticas de segurança mais claras;
* Facilidade de manutenção e auditoria.

Evita que todas as tabelas sejam colocadas em um único espaço de nomes, o que aumenta o risco de conflitos e dificulta o controle de acesso.

---

## 3. Modelo Lógico

O modelo lógico foi construído com base na normalização da planilha legada. As entidades centrais são:

* **Aluno** (id_aluno PK, nome, email, cidade, ativo)
* **Professor** (id_professor PK, nome, ativo)
* **Disciplina** (id_disciplina PK, nome)
* **Turma** (id_turma PK, id_disciplina FK, id_professor FK, ciclo, ativo)
* **Matrícula** (id_matricula PK, id_aluno FK, id_turma FK, ativo)
* **Nota** (id_nota PK, id_matricula FK, valor, ativo)

Relacionamentos principais:

* Um aluno pode ter várias matrículas (1:N).
* Uma turma pode receber várias matrículas (1:N).
* Uma disciplina pode ter várias turmas (1:N).
* Um professor pode lecionar várias turmas (1:N).
* Uma matrícula pode ter várias notas (1:N).

Este modelo facilita consultas sobre desempenho, vinculação de turmas e regras de integridade.

---

## 4. Normalização

A planilha original apresentava redundância e repetição de informações de aluno, disciplina e professor.

### 1ª Forma Normal (1FN)

* Todos os dados foram colocados em tabelas com atributos atômicos.
* Não há campos multivalorados ou listas dentro de uma mesma célula.

### 2ª Forma Normal (2FN)

* A separação em várias tabelas removeu dependências parciais.
* Dados do aluno, da disciplina e da matrícula residem em tabelas distintas.

### 3ª Forma Normal (3FN)

* Dependências transitivas foram eliminadas.
* Cada atributo depende diretamente da chave primária de sua entidade.

O resultado foi um banco com menor redundância, melhor integridade referencial e maior facilidade de manutenção.

---

## 5. Concorrência e Transações

No cenário em que dois operadores atualizam a mesma nota simultaneamente, o SGBD usa isolamento e bloqueios para preservar a consistência.

* Quando a primeira transação começa, o registro da nota pode ser bloqueado para escrita.
* A segunda transação aguarda até que a primeira seja confirmada ou revertida.
* Assim, apenas uma atualização é aplicada por vez, evitando condições de corrida.

O isolamento impede que leituras intermediárias de uma transação afetem outra, e a atomicidade garante rollback caso haja falha.

Com esse controle, o banco evita corrupção de dados e garante que o estado final seja consistente.

---

## Observação sobre o diagrama

A imagem do DER está disponível em `docs/DER.svg` e representa as entidades principais do modelo lógico e seus relacionamentos.
