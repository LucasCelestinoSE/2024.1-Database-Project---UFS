-- Desativar verificações
SET session_replication_role = replica;
SET SESSION check_function_bodies = false;
SET SESSION client_min_messages = warning;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS mydb;
SET search_path TO mydb;

-- -----------------------------------------------------
-- Table mydb.pessoas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.pessoas (
  idpessoas INT NOT NULL,
  datadenascimento DATE NULL,
  cpf VARCHAR(11) NOT NULL,
  endereco VARCHAR(45) NULL,
  numero_celular INT NULL,
  status VARCHAR(20) DEFAULT 'iNATIVO',
  email VARCHAR(45) NULL,
  PRIMARY KEY (idpessoas),
  UNIQUE (cpf)
);

-- -----------------------------------------------------
-- Table mydb.numero_celular
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.numero_celular (
  idnumero_telefone INT NOT NULL,
  numerotelefone INT NULL,
  pessoas_idpessoas INT NOT NULL,
  UNIQUE (numerotelefone),
  PRIMARY KEY (idnumero_telefone),
  CONSTRAINT fk_numero_telefone_pessoas
    FOREIGN KEY (pessoas_idpessoas)
    REFERENCES mydb.pessoas (idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índice separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_numero_telefone_pessoas_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_numero_telefone_pessoas_idx ON mydb.numero_celular (pessoas_idpessoas);
  END IF;
END $$;

-- -----------------------------------------------------
-- Table mydb.autor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.autor (
  idautor INT NOT NULL,
  biografia VARCHAR(45) NULL,
  PRIMARY KEY (idautor)
);

-- -----------------------------------------------------
-- Table mydb.nome
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.nome (
  idnome INT NOT NULL,
  primeironome VARCHAR(45) NOT NULL,
  sobrenome VARCHAR(45) NULL,
  pessoas_idpessoas INT NOT NULL,
  autor_idautor INT NULL,
  PRIMARY KEY (idnome),
  CONSTRAINT fk_nome_pessoas1
    FOREIGN KEY (pessoas_idpessoas)
    REFERENCES mydb.pessoas (idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_nome_autor1
    FOREIGN KEY (autor_idautor)
    REFERENCES mydb.autor (idautor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índices separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_nome_pessoas1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_nome_pessoas1_idx ON mydb.nome (pessoas_idpessoas);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_nome_autor1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_nome_autor1_idx ON mydb.nome (autor_idautor);
  END IF;
END $$;

-- -----------------------------------------------------
-- Table mydb.usuario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.usuario (
  pessoas_idpessoas INT NOT NULL,
  carteiraemitida VARCHAR(45) NULL,
  curso VARCHAR(45) NULL,
  matricula VARCHAR(45) NULL,
  UNIQUE (matricula),
  PRIMARY KEY (pessoas_idpessoas),
  CONSTRAINT fk_usuario_pessoas1
    FOREIGN KEY (pessoas_idpessoas)
    REFERENCES mydb.pessoas (idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table mydb.reserva
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.reserva (
  idreserva INT NOT NULL,
  data_reserva DATE NULL,
  titulo_id INT NOT NULL,
  status_reserva VARCHAR(20) DEFAULT 'SEM RESERVAS',
  usuario_pessoas_idpessoas INT NULL,
  PRIMARY KEY (idreserva),
  CONSTRAINT fk_reserva_usuario1
    FOREIGN KEY (usuario_pessoas_idpessoas)
    REFERENCES mydb.usuario (pessoas_idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índice separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_reserva_usuario1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_reserva_usuario1_idx ON mydb.reserva (usuario_pessoas_idpessoas);
  END IF;
END $$;

-- -----------------------------------------------------
-- Table mydb.emprestimo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.emprestimo (
  idemprestimo INT NOT NULL,
  status_emprestimo VARCHAR(15) DEFAULT 'SEM EMPRÉSTIMOS',
  isbn INT NOT NULL,
  usuario_pessoas_idpessoas INT NOT NULL,
  reserva_idreserva INT NULL,
  UNIQUE (isbn),
  PRIMARY KEY (idemprestimo),
  CONSTRAINT fk_emprestimo_usuario1
    FOREIGN KEY (usuario_pessoas_idpessoas)
    REFERENCES mydb.usuario (pessoas_idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_emprestimo_reserva1
    FOREIGN KEY (reserva_idreserva)
    REFERENCES mydb.reserva (idreserva)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índices separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_emprestimo_usuario1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_emprestimo_usuario1_idx ON mydb.emprestimo (usuario_pessoas_idpessoas);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_emprestimo_reserva1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_emprestimo_reserva1_idx ON mydb.emprestimo (reserva_idreserva);
  END IF;
END $$;

-- -----------------------------------------------------
-- Table mydb.bibliotecario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.bibliotecario (
  datacontratacao DATE NOT NULL,
  cargo VARCHAR(45) NULL,
  pessoas_idpessoas INT NOT NULL,
  emprestimo_idemprestimo INT NOT NULL,
  PRIMARY KEY (pessoas_idpessoas),
  CONSTRAINT fk_bibliotecario_pessoas1
    FOREIGN KEY (pessoas_idpessoas)
    REFERENCES mydb.pessoas (idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_bibliotecario_emprestimo1
    FOREIGN KEY (emprestimo_idemprestimo)
    REFERENCES mydb.emprestimo (idemprestimo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índice separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_bibliotecario_emprestimo1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_bibliotecario_emprestimo1_idx ON mydb.bibliotecario (emprestimo_idemprestimo);
  END IF;
END $$;

-- -----------------------------------------------------
-- Table mydb.titulos_virtuais
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.titulos_virtuais (
  isbn INT NOT NULL,
  tamanhodoarquivo FLOAT NOT NULL CHECK (tamanhodoarquivo > 0 AND tamanhodoarquivo < 5),
  edicao INT NOT NULL,
  publicacao DATE NOT NULL,
  tempodeduracao FLOAT NOT NULL CHECK (tempodeduracao > 0 AND tempodeduracao < 120),
  tipo VARCHAR(15) NOT NULL,
  formatodoarquivo VARCHAR(10) NOT NULL,
  idioma VARCHAR(15) NOT NULL,
  titulovirtual VARCHAR(45) NOT NULL,
  PRIMARY KEY (isbn)
);

-- -----------------------------------------------------
-- Table mydb.titulos_virtuais_has_usuario
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.titulos_virtuais_has_usuario (
  titulos_virtuais_isbn INT NOT NULL,
  usuario_pessoas_idpessoas INT NOT NULL,
  PRIMARY KEY (titulos_virtuais_isbn, usuario_pessoas_idpessoas),
  CONSTRAINT fk_titulos_virtuais_has_usuario_titulos_virtuais1
    FOREIGN KEY (titulos_virtuais_isbn)
    REFERENCES mydb.titulos_virtuais (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_titulos_virtuais_has_usuario_usuario1
    FOREIGN KEY (usuario_pessoas_idpessoas)
    REFERENCES mydb.usuario (pessoas_idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índices separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_titulos_virtuais_has_usuario_usuario1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_titulos_virtuais_has_usuario_usuario1_idx ON mydb.titulos_virtuais_has_usuario (usuario_pessoas_idpessoas);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_titulos_virtuais_has_usuario_titulos_virtuais1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_titulos_virtuais_has_usuario_titulos_virtuais1_idx ON mydb.titulos_virtuais_has_usuario (titulos_virtuais_isbn);
  END IF;
END $$;

-- -----------------------------------------------------
-- Table mydb.autor_has_titulos_virtuais
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.autor_has_titulos_virtuais (
  autor_idautor INT NOT NULL,
  titulos_virtuais_isbn INT NOT NULL,
  PRIMARY KEY (autor_idautor, titulos_virtuais_isbn),
  CONSTRAINT fk_autor_has_titulos_virtuais_autor1
    FOREIGN KEY (autor_idautor)
    REFERENCES mydb.autor (idautor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_autor_has_titulos_virtuais_titulos_virtuais1
    FOREIGN KEY (titulos_virtuais_isbn)
    REFERENCES mydb.titulos_virtuais (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índices separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_autor_has_titulos_virtuais_autor1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_autor_has_titulos_virtuais_autor1_idx ON mydb.autor_has_titulos_virtuais (autor_idautor);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_autor_has_titulos_virtuais_titulos_virtuais1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_autor_has_titulos_virtuais_titulos_virtuais1_idx ON mydb.autor_has_titulos_virtuais (titulos_virtuais_isbn);
  END IF;
END $$;

-- -----------------------------------------------------
-- Table mydb.titulos_fisicos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.titulos_fisicos (
  isbn INT NOT NULL,
  titulofisico VARCHAR(45) NOT NULL,
  publicacao DATE NOT NULL,
  exemplares VARCHAR(45) NULL,
  reserva_idreserva INT NOT NULL,
  PRIMARY KEY (isbn),
  CONSTRAINT fk_titulos_fisicos_reserva1
    FOREIGN KEY (reserva_idreserva)
    REFERENCES mydb.reserva (idreserva)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- -----------------------------------------------------
-- Table mydb.exemplares
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.exemplares (
  numero_exemplares INT NOT NULL,
  status_exemplar VARCHAR(20) DEFAULT 'INDISPONÍVEL',
  isbn INT NOT NULL,
  PRIMARY KEY (numero_exemplares),
  CONSTRAINT fk_exemplares_titulos_fisicos1
    FOREIGN KEY (isbn)
    REFERENCES mydb.titulos_fisicos (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table mydb.livro
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.livro (
  genero VARCHAR(30) NOT NULL,
  numero_de_paginas INT NOT NULL,
  edicao VARCHAR(15) NOT NULL,
  titulos_fisicos_isbn INT NOT NULL,
  PRIMARY KEY (titulos_fisicos_isbn),
  CONSTRAINT fk_livro_titulos_fisicos1
    FOREIGN KEY (titulos_fisicos_isbn)
    REFERENCES mydb.titulos_fisicos (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table mydb.artigo
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.artigo (
  titulo_periodico VARCHAR(45) NOT NULL,
  data_periodico DATE NOT NULL,
  numero_de_paginas INT NOT NULL,
  titulos_fisicos_isbn INT NOT NULL,
  PRIMARY KEY (titulos_fisicos_isbn),
  CONSTRAINT fk_artigo_titulos_fisicos1
    FOREIGN KEY (titulos_fisicos_isbn)
    REFERENCES mydb.titulos_fisicos (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table mydb.jornal
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.jornal (
  data_edicao DATE NOT NULL,
  nome_jornal VARCHAR(45) NOT NULL,
  numero_edicao INT NOT NULL,
  titulos_fisicos_isbn INT NOT NULL,
  PRIMARY KEY (titulos_fisicos_isbn),
  CONSTRAINT fk_jornal_titulos_fisicos1
    FOREIGN KEY (titulos_fisicos_isbn)
    REFERENCES mydb.titulos_fisicos (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table mydb.revista
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.revista (
  nome_revista VARCHAR(45) NOT NULL,
  numero_edicao INT NOT NULL,
  data_publicacao DATE NOT NULL,
  titulos_fisicos_isbn INT NOT NULL,
  PRIMARY KEY (titulos_fisicos_isbn),
  CONSTRAINT fk_revista_titulos_fisicos1
    FOREIGN KEY (titulos_fisicos_isbn)
    REFERENCES mydb.titulos_fisicos (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table mydb.editora
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.editora (
  id_editora VARCHAR(45) NOT NULL,
  telefone INT NOT NULL,
  site_editora VARCHAR(45) NULL,
  nome_editora VARCHAR(45) NOT NULL,
  email_editora VARCHAR(45) NOT NULL,
  endereco_editora VARCHAR(45) NULL,
  titulos_fisicos_isbn INT NOT NULL,
  PRIMARY KEY (id_editora, titulos_fisicos_isbn),
  CONSTRAINT fk_editora_titulos_fisicos1
    FOREIGN KEY (titulos_fisicos_isbn)
    REFERENCES mydb.titulos_fisicos (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índice separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_editora_titulos_fisicos1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_editora_titulos_fisicos1_idx ON mydb.editora (titulos_fisicos_isbn ASC);
  END IF;
END $$;
-- -----------------------------------------------------
-- Table mydb.devolucao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.devolucao (
  iddevolucao INT NOT NULL,
  status_devolucao VARCHAR(20) DEFAULT 'SEM EMPRESTIMOS',
  data_devolucao DATE NOT NULL,
  bibliotecario_pessoas_idpessoas INT NOT NULL,
  PRIMARY KEY (iddevolucao),
  CONSTRAINT fk_devolucao_bibliotecario1
    FOREIGN KEY (bibliotecario_pessoas_idpessoas)
    REFERENCES mydb.bibliotecario (pessoas_idpessoas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índice separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_devolucao_bibliotecario1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_devolucao_bibliotecario1_idx ON mydb.devolucao (bibliotecario_pessoas_idpessoas ASC);
  END IF;
END $$;
-- -----------------------------------------------------
-- Table mydb.emprestimo_has_devolucao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.emprestimo_has_devolucao (
  emprestimo_idemprestimo INT NOT NULL,
  devolucao_iddevolucao INT NOT NULL,
  PRIMARY KEY (emprestimo_idemprestimo, devolucao_iddevolucao),
  CONSTRAINT fk_emprestimo_has_devolucao_emprestimo1
    FOREIGN KEY (emprestimo_idemprestimo)
    REFERENCES mydb.emprestimo (idemprestimo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_emprestimo_has_devolucao_devolucao1
    FOREIGN KEY (devolucao_iddevolucao)
    REFERENCES mydb.devolucao (iddevolucao)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índices separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_emprestimo_has_devolucao_devolucao1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_emprestimo_has_devolucao_devolucao1_idx ON mydb.emprestimo_has_devolucao (devolucao_iddevolucao ASC);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_emprestimo_has_devolucao_emprestimo1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_emprestimo_has_devolucao_emprestimo1_idx ON mydb.emprestimo_has_devolucao (emprestimo_idemprestimo ASC);
  END IF;
END $$;
-- -----------------------------------------------------
-- Table mydb.multa
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.multa (
  idmulta INT NOT NULL,
  status_multa VARCHAR(20) DEFAULT 'SEM PENDENCIAS',
  data_multa DATE NOT NULL,
  valor_multa FLOAT NOT NULL,
  devolucao_iddevolucao INT NOT NULL,
  PRIMARY KEY (idmulta, devolucao_iddevolucao),
  CONSTRAINT fk_multa_devolucao1
    FOREIGN KEY (devolucao_iddevolucao)
    REFERENCES mydb.devolucao (iddevolucao)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índice separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_multa_devolucao1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_multa_devolucao1_idx ON mydb.multa (devolucao_iddevolucao ASC);
  END IF;
END $$;
-- -----------------------------------------------------
-- Table mydb.sessao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.sessao (
  idsessao INT NOT NULL,
  nome_sessao VARCHAR(30) NOT NULL,
  PRIMARY KEY (idsessao)
);

-- -----------------------------------------------------
-- Table mydb.categorias
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.categorias (
  idcategorias INT NOT NULL,
  descricao_categoria VARCHAR(45) NOT NULL,
  nome_categoria VARCHAR(20) NOT NULL,
  sessao_idsessao INT NOT NULL,
  PRIMARY KEY (idcategorias, sessao_idsessao),
  CONSTRAINT fk_categorias_sessao1
    FOREIGN KEY (sessao_idsessao)
    REFERENCES mydb.sessao (idsessao)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Criar índice separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_categorias_sessao1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_categorias_sessao1_idx ON mydb.categorias (sessao_idsessao ASC);
  END IF;
END $$;
-- -----------------------------------------------------
-- Table mydb.localizacao
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.localizacao (
  bloco VARCHAR(20) NOT NULL,
  corredor VARCHAR(20) NOT NULL,
  andar VARCHAR(20) NOT NULL,
  sessao_idsessao INT NOT NULL,
  PRIMARY KEY (sessao_idsessao),
  CONSTRAINT fk_localizacao_sessao1
    FOREIGN KEY (sessao_idsessao)
    REFERENCES mydb.sessao (idsessao)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- -----------------------------------------------------
-- Table mydb.autor_has_titulos_fisicos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.autor_has_titulos_fisicos (
  autor_idautor INT NOT NULL,
  titulos_fisicos_isbn INT NOT NULL,
  PRIMARY KEY (autor_idautor, titulos_fisicos_isbn),
  CONSTRAINT fk_autor_has_titulos_fisicos_autor1
    FOREIGN KEY (autor_idautor)
    REFERENCES mydb.autor (idautor)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_autor_has_titulos_fisicos_titulos_fisicos1
    FOREIGN KEY (titulos_fisicos_isbn)
    REFERENCES mydb.titulos_fisicos (isbn)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índices separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_autor_has_titulos_fisicos_titulos_fisicos1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_autor_has_titulos_fisicos_titulos_fisicos1_idx ON mydb.autor_has_titulos_fisicos (titulos_fisicos_isbn ASC);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_autor_has_titulos_fisicos_autor1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_autor_has_titulos_fisicos_autor1_idx ON mydb.autor_has_titulos_fisicos (autor_idautor ASC);
  END IF;
END $$;
-- -----------------------------------------------------
-- Table mydb.emprestimo_exemplares
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS mydb.emprestimo_exemplares (
  emprestimo_idemprestimo INT NOT NULL,
  exemplares_numero_exemplares INT NOT NULL,
  PRIMARY KEY (emprestimo_idemprestimo, exemplares_numero_exemplares),
  CONSTRAINT fk_emprestimo_exemplares_emprestimo1
    FOREIGN KEY (emprestimo_idemprestimo)
    REFERENCES mydb.emprestimo (idemprestimo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_emprestimo_exemplares_exemplares1
    FOREIGN KEY (exemplares_numero_exemplares)
    REFERENCES mydb.exemplares (numero_exemplares)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

-- Criar índices separadamente
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_emprestimo_exemplares_emprestimo1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_emprestimo_exemplares_emprestimo1_idx ON mydb.emprestimo_exemplares (emprestimo_idemprestimo ASC);
  END IF;
END $$;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_class c
    JOIN pg_namespace n ON n.oid = c.relnamespace
    WHERE c.relname = 'fk_emprestimo_exemplares_exemplares1_idx'
    AND n.nspname = 'mydb'
  ) THEN
    CREATE INDEX fk_emprestimo_exemplares_exemplares1_idx ON mydb.emprestimo_exemplares (exemplares_numero_exemplares ASC);
  END IF;
END $$;