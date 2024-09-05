-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Pessoas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pessoas` (
  `idPessoas` INT NOT NULL,
  `dataDeNascimento` DATE NULL,
  `cpf` VARCHAR(11) NOT NULL,
  `endereço` VARCHAR(45) NULL,
  `numero_celular()` INT NULL,
  `status` VARCHAR(20) DEFAULT 'iNATIVO',
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`idPessoas`),
  UNIQUE (`CPF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Numero Celular`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Numero Celular` (
  `idNumero Telefone` INT NOT NULL,
  `numeroTelefone` INT NULL,
  `Pessoas_idPessoas` INT NOT NULL,
  UNIQUE (`numeroTelefone`),
  PRIMARY KEY (`idNumero Telefone`),
  INDEX `fk_Numero Telefone_Pessoas_idx` (`Pessoas_idPessoas` ASC),
  CONSTRAINT `fk_Numero Telefone_Pessoas`
    FOREIGN KEY (`Pessoas_idPessoas`)
    REFERENCES `mydb`.`Pessoas` (`idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Autor` (
  `idAutor` INT NOT NULL,
  `Biografia` VARCHAR(45) NULL,
  PRIMARY KEY (`idAutor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`nome`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`nome` (
  `idNome` INT NOT NULL,
  `primerioNome` VARCHAR(45) NOT NULL,
  `sobrenome` VARCHAR(45) NULL,
  `Pessoas_idPessoas` INT NOT NULL,
  `Autor_idAutor` INT NULL,
  PRIMARY KEY (`idNome`),
  INDEX `fk_nome_Pessoas1_idx` (`Pessoas_idPessoas` ASC),
  INDEX `fk_nome_Autor1_idx` (`Autor_idAutor` ASC),
  CONSTRAINT `fk_nome_Pessoas1`
    FOREIGN KEY (`Pessoas_idPessoas`)
    REFERENCES `mydb`.`Pessoas` (`idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_nome_Autor1`
    FOREIGN KEY (`Autor_idAutor`)
    REFERENCES `mydb`.`Autor` (`idAutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Usuario` (
  `Pessoas_idPessoas` INT NOT NULL,
  `CarteiraEmitida` VARCHAR(45) NULL,
  `curso` VARCHAR(45) NULL,
  `matricula` VARCHAR(45) NULL,
  UNIQUE (`matricula`),
  PRIMARY KEY (`Pessoas_idPessoas`),
  CONSTRAINT `fk_Usuario_Pessoas1`
    FOREIGN KEY (`Pessoas_idPessoas`)
    REFERENCES `mydb`.`Pessoas` (`idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Reserva` (
  `idReserva` INT NOT NULL,
  `Data_Reserva` DATE NULL,
  `Titulo_Id` INT NOT NULL,
  `Status_reserva` VARCHAR(20) DEFAULT 'SEM RESERVAS',
  `Usuario_Pessoas_idPessoas` INT NULL,
  PRIMARY KEY (`idReserva`),
  INDEX `fk_Reserva_Usuario1_idx` (`Usuario_Pessoas_idPessoas` ASC),
  CONSTRAINT `fk_Reserva_Usuario1`
    FOREIGN KEY (`Usuario_Pessoas_idPessoas`)
    REFERENCES `mydb`.`Usuario` (`Pessoas_idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Emprestimo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Emprestimo` (
  `idEmprestimo` INT NOT NULL,
  `Status_Emprestimo` VARCHAR(15) DEFAULT 'SEM EMPRÉSTIMOS',
  `ISBN` INT NOT NULL,
  `Usuario_Pessoas_idPessoas` INT NOT NULL,
  `Reserva_idReserva` INT NULL,
  UNIQUE (`ISBN`),
  PRIMARY KEY (`idEmprestimo`),
  INDEX `fk_Emprestimo_Usuario1_idx` (`Usuario_Pessoas_idPessoas` ASC),
  INDEX `fk_Emprestimo_Reserva1_idx` (`Reserva_idReserva` ASC),
  CONSTRAINT `fk_Emprestimo_Usuario1`
    FOREIGN KEY (`Usuario_Pessoas_idPessoas`)
    REFERENCES `mydb`.`Usuario` (`Pessoas_idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emprestimo_Reserva1`
    FOREIGN KEY (`Reserva_idReserva`)
    REFERENCES `mydb`.`Reserva` (`idReserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Bibliotecário`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Bibliotecário` (
  `dataContratação` DATE NOT NULL,
  `cargo` VARCHAR(45) NULL,
  `Pessoas_idPessoas` INT NOT NULL,
  `Emprestimo_idEmprestimo` INT NOT NULL,
  PRIMARY KEY (`Pessoas_idPessoas`),
  INDEX `fk_Bibliotecário_Emprestimo1_idx` (`Emprestimo_idEmprestimo` ASC),
  CONSTRAINT `fk_Bibliotecário_Pessoas1`
    FOREIGN KEY (`Pessoas_idPessoas`)
    REFERENCES `mydb`.`Pessoas` (`idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bibliotecário_Emprestimo1`
    FOREIGN KEY (`Emprestimo_idEmprestimo`)
    REFERENCES `mydb`.`Emprestimo` (`idEmprestimo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Titulos Virtuais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Titulos Virtuais` (
  `ISBN` INT NOT NULL,
  `Tamanho do arquivo` FLOAT NOT NULL, CHECK (TamanhodoArquivo > 0 AND TamanhodoArquivo < 5),
  `Edicao` INT NOT NULL,
  `Publicacao` DATE NOT NULL,
  `Tempo de Duracao` FLOAT NOT NULL, CHECK (TempodeDuracao > 0 AND TempodeDuracao < 120),
  `Tipo` VARCHAR(15) NOT NULL,
  `Formato do arquivo` VARCHAR(10) NOT NULL,
  `Idioma` VARCHAR(15) NOT NULL,
  `Titulo virtual` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`ISBN`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Titulos Virtuais_has_Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Titulos Virtuais_has_Usuario` (
  `Titulos Virtuais_ISBN` INT NOT NULL,
  `Usuario_Pessoas_idPessoas` INT NOT NULL,
  PRIMARY KEY (`Titulos Virtuais_ISBN`, `Usuario_Pessoas_idPessoas`),
  INDEX `fk_Titulos Virtuais_has_Usuario_Usuario1_idx` (`Usuario_Pessoas_idPessoas` ASC),
  INDEX `fk_Titulos Virtuais_has_Usuario_Titulos Virtuais1_idx` (`Titulos Virtuais_ISBN` ASC),
  CONSTRAINT `fk_Titulos Virtuais_has_Usuario_Titulos Virtuais1`
    FOREIGN KEY (`Titulos Virtuais_ISBN`)
    REFERENCES `mydb`.`Titulos Virtuais` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Titulos Virtuais_has_Usuario_Usuario1`
    FOREIGN KEY (`Usuario_Pessoas_idPessoas`)
    REFERENCES `mydb`.`Usuario` (`Pessoas_idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Autor_has_Titulos Virtuais`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Autor_has_Titulos Virtuais` (
  `Autor_idAutor` INT NOT NULL,
  `Titulos Virtuais_ISBN` INT NOT NULL,
  PRIMARY KEY (`Autor_idAutor`, `Titulos Virtuais_ISBN`),
  INDEX `fk_Autor_has_Titulos Virtuais_Titulos Virtuais1_idx` (`Titulos Virtuais_ISBN` ASC),
  INDEX `fk_Autor_has_Titulos Virtuais_Autor1_idx` (`Autor_idAutor` ASC),
  CONSTRAINT `fk_Autor_has_Titulos Virtuais_Autor1`
    FOREIGN KEY (`Autor_idAutor`)
    REFERENCES `mydb`.`Autor` (`idAutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Autor_has_Titulos Virtuais_Titulos Virtuais1`
    FOREIGN KEY (`Titulos Virtuais_ISBN`)
    REFERENCES `mydb`.`Titulos Virtuais` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Titulos fisicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Titulos fisicos` (
  `ISBN` INT NOT NULL,
  `Titulo Fisico` VARCHAR(45) NOT NULL,
  `Publicacao` DATE NOT NULL,
  `Exemplares()` VARCHAR(45) NULL,
  `Reserva_idReserva` INT NOT NULL,
  PRIMARY KEY (`ISBN`),
  INDEX `fk_Titulos fisicos_Reserva1_idx` (`Reserva_idReserva` ASC),
  CONSTRAINT `fk_Titulos fisicos_Reserva1`
    FOREIGN KEY (`Reserva_idReserva`)
    REFERENCES `mydb`.`Reserva` (`idReserva`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Exemplares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Exemplares` (
  `Numero Exemplares` INT NOT NULL,
  `Status Exemplar` VARCHAR(20) DEFAULT 'INDISPONÍVEL',
  `ISBN` INT NOT NULL,
  PRIMARY KEY (`Numero Exemplares`, `ISBN`),
  INDEX `fk_Exemplares_Titulos fisicos1_idx` (`ISBN` ASC),
  CONSTRAINT `fk_Exemplares_Titulos fisicos1`
    FOREIGN KEY (`ISBN`)
    REFERENCES `mydb`.`Titulos fisicos` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Livro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Livro` (
  `Genero` VARCHAR(30) NOT NULL,
  `Numero de Paginas` INT NOT NULL,
  `Edicao` VARCHAR(15) NOT NULL,
  `Titulos fisicos_ISBN` INT NOT NULL,
  PRIMARY KEY (`Titulos fisicos_ISBN`),
  CONSTRAINT `fk_Livro_Titulos fisicos1`
    FOREIGN KEY (`Titulos fisicos_ISBN`)
    REFERENCES `mydb`.`Titulos fisicos` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Artigo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Artigo` (
  `Titulo_Periodico` VARCHAR(45) NOT NULL,
  `Data_Periodico` DATE NOT NULL,
  `Numero de paginas` INT NOT NULL,
  `Titulos fisicos_ISBN` INT NOT NULL,
  PRIMARY KEY (`Titulos fisicos_ISBN`),
  CONSTRAINT `fk_Artigo_Titulos fisicos1`
    FOREIGN KEY (`Titulos fisicos_ISBN`)
    REFERENCES `mydb`.`Titulos fisicos` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Jornal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Jornal` (
  `Data_Edicao` DATE NOT NULL,
  `Nome_Jornal` VARCHAR(45) NOT NULL,
  `Numero_Edicao` INT NOT NULL,
  `Titulos fisicos_ISBN` INT NOT NULL,
  PRIMARY KEY (`Titulos fisicos_ISBN`),
  CONSTRAINT `fk_Jornal_Titulos fisicos1`
    FOREIGN KEY (`Titulos fisicos_ISBN`)
    REFERENCES `mydb`.`Titulos fisicos` (`ISBN`)
    ON DELETE NO ACTIONw
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Revista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Revista` (
  `Nome_Revista` VARCHAR(45) NOT NULL,
  `Numero_Edicao` INT NOT NULL,
  `Data_Publicacao` DATE NOT NULL,
  `Titulos fisicos_ISBN` INT NOT NULL,
  PRIMARY KEY (`Titulos fisicos_ISBN`),
  CONSTRAINT `fk_Revista_Titulos fisicos1`
    FOREIGN KEY (`Titulos fisicos_ISBN`)
    REFERENCES `mydb`.`Titulos fisicos` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Editora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Editora` (
  `ID Editora` VARCHAR(45) NOT NULL,
  `Telefone` INT NOT NULL,
  `Site_Editora` VARCHAR(45) NULL,
  `Nome_Editora` VARCHAR(45) NOT NULL,
  `E-mail_Editora` VARCHAR(45) NOT NULL,
  `Endereco_Editora` VARCHAR(45) NULL,
  `Titulos fisicos_ISBN` INT NOT NULL,
  PRIMARY KEY (`ID Editora`, `Titulos fisicos_ISBN`),
  INDEX `fk_Editora_Titulos fisicos1_idx` (`Titulos fisicos_ISBN` ASC),
  CONSTRAINT `fk_Editora_Titulos fisicos1`
    FOREIGN KEY (`Titulos fisicos_ISBN`)
    REFERENCES `mydb`.`Titulos fisicos` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Contém`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Contém` (
  `Emprestimo_idEmprestimo` INT NOT NULL,
  `Exemplares_Numero Exemplares` INT NOT NULL,
  PRIMARY KEY (`Emprestimo_idEmprestimo`, `Exemplares_Numero Exemplares`),
  INDEX `fk_Emprestimo_has_Exemplares_Exemplares1_idx` (`Exemplares_Numero Exemplares` ASC),
  INDEX `fk_Emprestimo_has_Exemplares_Emprestimo1_idx` (`Emprestimo_idEmprestimo` ASC),
  CONSTRAINT `fk_Emprestimo_has_Exemplares_Emprestimo1`
    FOREIGN KEY (`Emprestimo_idEmprestimo`)
    REFERENCES `mydb`.`Emprestimo` (`idEmprestimo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emprestimo_has_Exemplares_Exemplares1`
    FOREIGN KEY (`Exemplares_Numero Exemplares`)
    REFERENCES `mydb`.`Exemplares` (`Numero Exemplares`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Devolucao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Devolucao` (
  `idDevolucao` INT NOT NULL,
  `Status_Devolucao` VARCHAR(20) DEFAULT 'SEM EMPRESTIMOS',
  `Data_Devolucao` DATE NOT NULL,
  `Bibliotecário_Pessoas_idPessoas` INT NOT NULL,
  PRIMARY KEY (`idDevolucao`),
  INDEX `fk_Devolucao_Bibliotecário1_idx` (`Bibliotecário_Pessoas_idPessoas` ASC),
  CONSTRAINT `fk_Devolucao_Bibliotecário1`
    FOREIGN KEY (`Bibliotecário_Pessoas_idPessoas`)
    REFERENCES `mydb`.`Bibliotecário` (`Pessoas_idPessoas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Emprestimo_has_Devolucao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Emprestimo_has_Devolucao` (
  `Emprestimo_idEmprestimo` INT NOT NULL,
  `Devolucao_idDevolucao` INT NOT NULL,
  PRIMARY KEY (`Emprestimo_idEmprestimo`, `Devolucao_idDevolucao`),
  INDEX `fk_Emprestimo_has_Devolucao_Devolucao1_idx` (`Devolucao_idDevolucao` ASC),
  INDEX `fk_Emprestimo_has_Devolucao_Emprestimo1_idx` (`Emprestimo_idEmprestimo` ASC),
  CONSTRAINT `fk_Emprestimo_has_Devolucao_Emprestimo1`
    FOREIGN KEY (`Emprestimo_idEmprestimo`)
    REFERENCES `mydb`.`Emprestimo` (`idEmprestimo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emprestimo_has_Devolucao_Devolucao1`
    FOREIGN KEY (`Devolucao_idDevolucao`)
    REFERENCES `mydb`.`Devolucao` (`idDevolucao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Multa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Multa` (
  `idMulta` INT NOT NULL,
  `Status_Multa` VARCHAR(20) DEFAULT 'SEM PENDENCIAS',
  `Data_Multa` DATE NOT NULL,
  `Valor_Multa` FLOAT NOT NULL,
  `Devolucao_idDevolucao` INT NOT NULL,
  PRIMARY KEY (`idMulta`, `Devolucao_idDevolucao`),
  INDEX `fk_Multa_Devolucao1_idx` (`Devolucao_idDevolucao` ASC),
  CONSTRAINT `fk_Multa_Devolucao1`
    FOREIGN KEY (`Devolucao_idDevolucao`)
    REFERENCES `mydb`.`Devolucao` (`idDevolucao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Sessao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Sessao` (
  `idSessao` INT NOT NULL,
  `Nome_Sessao` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`idSessao`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Categorias` (
  `idCategorias` INT NOT NULL,
  `Descricao_Categoria` VARCHAR(45) NOT NULL,
  `Nome_Categoria` VARCHAR(20) NOT NULL,
  `Sessao_idSessao` INT NOT NULL,
  PRIMARY KEY (`idCategorias`, `Sessao_idSessao`),
  INDEX `fk_Categorias_Sessao1_idx` (`Sessao_idSessao` ASC),
  CONSTRAINT `fk_Categorias_Sessao1`
    FOREIGN KEY (`Sessao_idSessao`)
    REFERENCES `mydb`.`Sessao` (`idSessao`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Exemplares_has_Categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Exemplares_has_Categorias` (
  `Exemplares_Numero Exemplares` INT NOT NULL,
  `Categorias_idCategorias` INT NOT NULL,
  PRIMARY KEY (`Exemplares_Numero Exemplares`, `Categorias_idCategorias`),
  INDEX `fk_Exemplares_has_Categorias_Categorias1_idx` (`Categorias_idCategorias` ASC),
  INDEX `fk_Exemplares_has_Categorias_Exemplares1_idx` (`Exemplares_Numero Exemplares` ASC),
  CONSTRAINT `fk_Exemplares_has_Categorias_Exemplares1`
    FOREIGN KEY (`Exemplares_Numero Exemplares`)
    REFERENCES `mydb`.`Exemplares` (`Numero Exemplares`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Exemplares_has_Categorias_Categorias1`
    FOREIGN KEY (`Categorias_idCategorias`)
    REFERENCES `mydb`.`Categorias` (`idCategorias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Localizacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Localizacao` (
  `Bloco` VARCHAR(20) NOT NULL,
  `Corredor` VARCHAR(20) NOT NULL,
  `Andar` VARCHAR(20) NOT NULL,
  `Sessao_idSessao` INT NOT NULL,
  PRIMARY KEY (`Sessao_idSessao`),
  CONSTRAINT `fk_Localizao_Sessao1`
    FOREIGN KEY (`Sessao_idSessao`)
    REFERENCES `mydb`.`Sessao` (`idSessao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Autor_has_Titulos fisicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Autor_has_Titulos fisicos` (
  `Autor_idAutor` INT NOT NULL,
  `Titulos fisicos_ISBN` INT NOT NULL,
  PRIMARY KEY (`Autor_idAutor`, `Titulos fisicos_ISBN`),
  INDEX `fk_Autor_has_Titulos fisicos_Titulos fisicos1_idx` (`Titulos fisicos_ISBN` ASC),
  INDEX `fk_Autor_has_Titulos fisicos_Autor1_idx` (`Autor_idAutor` ASC),
  CONSTRAINT `fk_Autor_has_Titulos fisicos_Autor1`
    FOREIGN KEY (`Autor_idAutor`)
    REFERENCES `mydb`.`Autor` (`idAutor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Autor_has_Titulos fisicos_Titulos fisicos1`
    FOREIGN KEY (`Titulos fisicos_ISBN`)
    REFERENCES `mydb`.`Titulos fisicos` (`ISBN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb` ;

-- -----------------------------------------------------
-- Placeholder table for view `mydb`.`view1`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`view1` (`id` INT);

-- -----------------------------------------------------
-- View `mydb`.`view1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`view1`;
USE `mydb`;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
