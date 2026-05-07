-- =====================================================
-- Script único de implantação para o banco de dados SigaEdu
-- Contém DDL, DCL, DML e consultas exigidas
-- =====================================================

DROP DATABASE IF EXISTS sigaedu;
CREATE DATABASE sigaedu;
USE sigaedu;

CREATE SCHEMA IF NOT EXISTS academico;
CREATE SCHEMA IF NOT EXISTS seguranca;

-- =====================================================
-- Estrutura de tabelas com Soft Delete
-- =====================================================
CREATE TABLE academico.aluno (
    id_aluno INT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL,
    cidade VARCHAR(120) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE academico.professor (
    id_professor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE academico.disciplina (
    id_disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL
);

CREATE TABLE academico.turma (
    id_turma INT AUTO_INCREMENT PRIMARY KEY,
    id_disciplina INT NOT NULL,
    id_professor INT NOT NULL,
    ciclo VARCHAR(10) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_disciplina) REFERENCES academico.disciplina(id_disciplina),
    FOREIGN KEY (id_professor) REFERENCES academico.professor(id_professor)
);

CREATE TABLE academico.matricula (
    id_matricula INT AUTO_INCREMENT PRIMARY KEY,
    id_aluno INT NOT NULL,
    id_turma INT NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_aluno) REFERENCES academico.aluno(id_aluno),
    FOREIGN KEY (id_turma) REFERENCES academico.turma(id_turma)
);

CREATE TABLE academico.nota (
    id_nota INT AUTO_INCREMENT PRIMARY KEY,
    id_matricula INT NOT NULL,
    valor DECIMAL(4,2) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (id_matricula) REFERENCES academico.matricula(id_matricula)
);

-- =====================================================
-- Dados de exemplo normalizados
-- =====================================================
INSERT INTO academico.aluno (id_aluno, nome, email, cidade, ativo) VALUES
(2026001, 'Ana Beatriz Lima', 'ana.lima@aluno.edu.br', 'Braganca Paulista/SP', 1),
(2026002, 'Bruno Henrique Souza', 'bruno.souza@aluno.edu.br', 'Atibaia/SP', 1),
(2026003, 'Camila Ferreira', 'camila.ferreira@aluno.edu.br', 'Jundiai/SP', 1),
(2026004, 'Diego Martins', 'diego.martins@aluno.edu.br', 'Campinas/SP', 1),
(2026005, 'Eduarda Nunes', 'eduarda.nunes@aluno.edu.br', 'Itatiba/SP', 1),
(2026006, 'Felipe Araujo', 'felipe.araujo@aluno.edu.br', 'Louveira/SP', 1),
(2025010, 'Gabriela Torres', 'gabriela.torres@aluno.edu.br', 'Nazare Paulista/SP', 1),
(2025011, 'Helena Rocha', 'helena.rocha@aluno.edu.br', 'Piracaia/SP', 1),
(2025012, 'Igor Santana', 'igor.santana@aluno.edu.br', 'Jarinu/SP', 1);

INSERT INTO academico.professor (nome) VALUES
('Carlos'),
('Ana'),
('Roberto');

INSERT INTO academico.disciplina (nome) VALUES
('ADS101'),
('ADS102'),
('ADS103'),
('ADS104'),
('ADS105'),
('ADS106'),
('Banco de Dados');

INSERT INTO academico.turma (id_disciplina, id_professor, ciclo) VALUES
(1, 1, '2026/1'),
(2, 2, '2026/1'),
(3, 3, '2026/1'),
(4, 1, '2026/1'),
(5, 2, '2026/1'),
(6, 3, '2026/1'),
(7, 1, '2026/1');

INSERT INTO academico.matricula (id_aluno, id_turma, ativo) VALUES
(2026001, 5, 1),
(2026002, 1, 1),
(2026002, 3, 1),
(2026002, 4, 1),
(2026003, 1, 1),
(2026003, 2, 1),
(2026003, 6, 1),
(2026004, 3, 1),
(2026004, 4, 1),
(2026004, 5, 1),
(2026005, 2, 1),
(2026005, 4, 1),
(2026005, 6, 1),
(2026006, 1, 1),
(2026006, 3, 1),
(2026006, 5, 1),
(2025010, 1, 1),
(2025010, 2, 1),
(2025011, 3, 1),
(2025011, 4, 1),
(2025012, 5, 1),
(2025012, 6, 1);

INSERT INTO academico.nota (id_matricula, valor, ativo) VALUES
(1, 8.50, 1),
(2, 5.00, 1),
(3, 7.00, 1),
(4, 6.50, 1),
(5, 9.00, 1),
(6, 4.50, 1),
(7, 6.00, 1),
(8, 5.50, 1),
(9, 7.50, 1),
(10, 8.00, 1),
(11, 3.50, 1),
(12, 6.00, 1);

-- =====================================================
-- Segurança e governança
-- =====================================================
CREATE ROLE IF NOT EXISTS professor_role;
CREATE ROLE IF NOT EXISTS coordenador_role;

GRANT SELECT (id_aluno, nome, cidade, ativo) ON academico.aluno TO professor_role;
GRANT SELECT ON academico.disciplina TO professor_role;
GRANT SELECT ON academico.turma TO professor_role;
GRANT SELECT ON academico.matricula TO professor_role;
GRANT UPDATE (valor) ON academico.nota TO professor_role;

GRANT ALL PRIVILEGES ON academico.* TO coordenador_role;

CREATE VIEW academico.aluno_publico AS
SELECT id_aluno, nome
FROM academico.aluno;

GRANT SELECT ON academico.aluno_publico TO professor_role;

CREATE USER IF NOT EXISTS 'professor'@'localhost' IDENTIFIED BY 'professor123';
CREATE USER IF NOT EXISTS 'coordenador'@'localhost' IDENTIFIED BY 'coordenador123';
GRANT professor_role TO 'professor'@'localhost';
GRANT coordenador_role TO 'coordenador'@'localhost';
SET DEFAULT ROLE professor_role FOR 'professor'@'localhost';
SET DEFAULT ROLE coordenador_role FOR 'coordenador'@'localhost';

-- =====================================================
-- Consultas solicitadas
-- =====================================================

-- 1. Listagem de matriculados em 2026/1
SELECT a.nome AS aluno,
       d.nome AS disciplina,
       t.ciclo
FROM academico.aluno AS a
JOIN academico.matricula AS m ON a.id_aluno = m.id_aluno
JOIN academico.turma AS t ON m.id_turma = t.id_turma
JOIN academico.disciplina AS d ON t.id_disciplina = d.id_disciplina
WHERE t.ciclo = '2026/1';

-- 2. Média de notas por disciplina menor que 6.0
SELECT d.nome AS disciplina,
       AVG(n.valor) AS media
FROM academico.nota AS n
JOIN academico.matricula AS m ON n.id_matricula = m.id_matricula
JOIN academico.turma AS t ON m.id_turma = t.id_turma
JOIN academico.disciplina AS d ON t.id_disciplina = d.id_disciplina
WHERE n.ativo = 1
GROUP BY d.nome
HAVING AVG(n.valor) < 6.0;

-- 3. Alocação de docentes (LEFT JOIN para incluir professores sem turmas)
SELECT p.nome AS professor,
       d.nome AS disciplina
FROM academico.professor AS p
LEFT JOIN academico.turma AS t ON p.id_professor = t.id_professor
LEFT JOIN academico.disciplina AS d ON t.id_disciplina = d.id_disciplina;

-- 4. Melhor nota em Banco de Dados
SELECT a.nome AS aluno,
       n.valor
FROM academico.nota AS n
JOIN academico.matricula AS m ON n.id_matricula = m.id_matricula
JOIN academico.aluno AS a ON m.id_aluno = a.id_aluno
JOIN academico.turma AS t ON m.id_turma = t.id_turma
JOIN academico.disciplina AS d ON t.id_disciplina = d.id_disciplina
WHERE d.nome = 'Banco de Dados'
  AND n.valor = (
      SELECT MAX(n2.valor)
      FROM academico.nota AS n2
      JOIN academico.matricula AS m2 ON n2.id_matricula = m2.id_matricula
      JOIN academico.turma AS t2 ON m2.id_turma = t2.id_turma
      JOIN academico.disciplina AS d2 ON t2.id_disciplina = d2.id_disciplina
      WHERE d2.nome = 'Banco de Dados'
  );

-- =====================================================
-- Verificação rápida
-- =====================================================
SELECT COUNT(*) AS total_alunos FROM academico.aluno;
SELECT COUNT(*) AS total_matriculas FROM academico.matricula;
SELECT COUNT(*) AS total_notas FROM academico.nota;
