-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

DROP SCHEMA IF EXISTS `OBRANDO_EN_TI_BD` ;

CREATE SCHEMA IF NOT EXISTS `OBRANDO_EN_TI_BD`; -- DEFAULT CHARACTER SET utf8 ;
USE `OBRANDO_EN_TI_BD` ;

DROP TABLE IF EXISTS `perfil_usuario` ;

CREATE TABLE IF NOT EXISTS `perfil_usuario` (
  `dni` INT(8) UNIQUE NOT NULL,
  `apellido` VARCHAR(20) NOT NULL,
  `nombres` VARCHAR(40) NOT NULL,
  `calle` VARCHAR(40) NOT NULL,
  `nro_alt` INT NULL DEFAULT NULL,
  `ciudad` VARCHAR(40) NOT NULL,
  `provincia` VARCHAR(40) NOT NULL,
  `fk_usuario_log` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`dni`),
  FOREIGN KEY (`fk_usuario_log`) REFERENCES `usuario_log`(`mail`) ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `donante` ;

CREATE TABLE IF NOT EXISTS `donante` (
  `dni` INT(8) UNIQUE NOT NULL,
  `apellido` VARCHAR(20) NOT NULL,
  `nombres` VARCHAR(40) NOT NULL,
  `fk_perfil` INT(8) NOT NULL,
  PRIMARY KEY (`dni`),
  FOREIGN KEY (`fk_perfil`) REFERENCES `perfil_usuario`(`dni`) ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `beneficiario` ;

CREATE TABLE IF NOT EXISTS `beneficiario` (
  `dni` INT(8) UNIQUE NOT NULL,
  `nro_seg` INT(4) NOT NULL,
  `apellido` VARCHAR(20) NOT NULL,
  `nombres` VARCHAR(40) NOT NULL,
  `fk_perfil` INT(8) NOT NULL,
  `fk_propiedad` INT(4) NOT NULL,
  PRIMARY KEY (`dni`),
  FOREIGN KEY (`fk_perfil`) REFERENCES `perfil_usuario`(`dni`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_propiedad`) REFERENCES `propiedad`(`id_propiedad`) ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `gestor_ong` ;

CREATE TABLE IF NOT EXISTS `gestor_ong` (
	`cuil` INT(11) UNIQUE NOT NULL,
    `apellido` VARCHAR(20) NOT NULL,
    `nombres` VARCHAR(40) NOT NULL,
    `cargo` VARCHAR(30) NOT NULL,
    `fk_beneficiario` INT(8) NOT NULL,
    `fk_usuario_log` VARCHAR(30) NOT NULL,
      PRIMARY KEY (`cuil`),
      FOREIGN KEY (`fk_usuario_log`) REFERENCES `usuario_log`(`mail`) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (`fk_beneficiario`) REFERENCES `beneficiario`(`dni`) ON DELETE NO ACTION ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `donacion` ;

CREATE TABLE IF NOT EXISTS `donacion` (
 `iddonacion` INT(4) NOT NULL,
  `tipo` VARCHAR(100) NOT NULL, -- describe en pocas palabras el tipo de donación que hará 
  `descripcion` VARCHAR(300) NOT NULL,
 `fk_donante` INT(8) NOT NULL,
 `fk_ong` INT(11) NOT NULL,
  PRIMARY KEY (`iddonacion`),
  FOREIGN KEY (`fk_donante`) REFERENCES `donante`(`dni`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_ong`) REFERENCES `gestor_ong` (`cuil`) ON DELETE NO ACTION ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `usuario_log` ;

CREATE TABLE IF NOT EXISTS `usuario_log` (
 `mail` VARCHAR(30) NOT NULL,
  `nombre_usuario` VARCHAR(15) NOT NULL,
  `contraseña` VARCHAR(20) NOT NULL,
  `fk_perfil_usuario` INT(8) NOT NULL,
  `fk_gestor` INT(11) NOT NULL,
  PRIMARY KEY (`mail`),
  FOREIGN KEY (`fk_perfil_usuario`) REFERENCES `perfil_usuario`(`dni`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_gestor`) REFERENCES `gestor_ong` (`cuil`) ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `posteo` ;

CREATE TABLE IF NOT EXISTS `posteo` (
 `nombre_usuario` VARCHAR(15) NOT NULL,
  `titulo` VARCHAR(40) NOT NULL,
  `comentario` VARCHAR(300) NOT NULL,
 `fk_usuario_log` VARCHAR(30) NOT NULL,
 `fk_ong` INT(4) NOT NULL,
  PRIMARY KEY (`nombre_usuario`),
  FOREIGN KEY (`fk_usuario_log`) REFERENCES `usuario_log`(`mail`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`fk_ong`) REFERENCES `gestor_ong` (`cuil`) ON DELETE NO ACTION ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `propiedad` ;

CREATE TABLE IF NOT EXISTS `propiedad` (
  `id_propiedad` INT(4) NOT NULL,
  `calle` VARCHAR(40) NOT NULL,
  `nro_alt` INT NOT NULL,
  `ciudad` VARCHAR(40) NOT NULL,
  `provincia` VARCHAR(40) NOT NULL,
  `superficie` DECIMAL(4,2) NOT NULL,
  `tipo` VARCHAR(15) NOT NULL,
  `estado_prop` ENUM ('pendiente','enproceso','terminado'),
  `fk_beneficiario` INT(8) NOT NULL,
 PRIMARY KEY (`id_propiedad`),
  FOREIGN KEY (`fk_beneficiario`) REFERENCES `beneficiario`(`dni`)ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `obra` ;

CREATE TABLE IF NOT EXISTS `obra` (
  `id_obra` INT(4) NOT NULL,
  `calle` VARCHAR(40) NOT NULL,
  `nro_alt` INT NOT NULL,
  `ciudad` VARCHAR(40) NOT NULL,
  `provincia` VARCHAR(40) NOT NULL,
  `presupuesto` DECIMAL(6,2) NOT NULL,
  `estado_prop` ENUM ('pendiente','gestion','terminado'),
  `f_inicio` DATE NOT NULL,
  `f_fin` DATE NOT NULL,
  `fk_propiedad` INT(4) NOT NULL,
  `fk_gestor` INT(11) NOT NULL,
	PRIMARY KEY (`id_obra`),
	FOREIGN KEY (`fk_gestor`) REFERENCES `gestor_ong`(`cuil`) ON DELETE CASCADE ON UPDATE CASCADE)
	ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;

DROP TABLE IF EXISTS `se_realiza` ;

CREATE TABLE IF NOT EXISTS `se_realiza` (
 `id_obra` INT(4) NOT NULL,
  `id_propiedad` INT(4) NOT NULL,
  PRIMARY KEY (`id_obra`,`id_propiedad`),
  FOREIGN KEY (`id_obra`) REFERENCES `obra`(`id_obra`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`id_propiedad`) REFERENCES `propiedad` (`id_propiedad`) ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE = InnoDB;
-- DEFAULT CHARACTER SET = utf8;