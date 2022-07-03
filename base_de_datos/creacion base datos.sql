DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE IF NOT EXISTS biblioteca;
USE biblioteca;

CREATE TABLE IF NOT EXISTS editorial(
    id_editorial INT UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    correo VARCHAR(45),
    telefono VARCHAR(25),
    fecha_fundacion DATE,
    PRIMARY KEY (id_editorial)
);

CREATE TABLE IF NOT EXISTS libro(
    id_libro INT UNSIGNED AUTO_INCREMENT NOT NULL,
    fk_editorial INT UNSIGNED NOT NULL,
    titulo VARCHAR(60) NOT NULL,
    fecha_de_publicacion DATE,
    PRIMARY KEY (id_libro),
    FOREIGN KEY (fk_editorial) REFERENCES editorial (id_editorial)
);

CREATE TABLE IF NOT EXISTS autor(
    id_autor INT UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30),
    fecha_nacimiento DATE,
    PRIMARY KEY (id_autor)
);

CREATE TABLE IF NOT EXISTS idioma(
    id_idioma INT UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_idioma)
);

CREATE TABLE IF NOT EXISTS estado(
    id_estado INT UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_estado)
);

CREATE TABLE IF NOT EXISTS copia(
    id_copia INT UNSIGNED AUTO_INCREMENT NOT NULL,
    fk_libro INT UNSIGNED NOT NULL,
    fk_idioma INT UNSIGNED NOT NULL,
    fk_estado INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_copia),
    FOREIGN KEY (fk_libro) REFERENCES libro (id_libro),
    FOREIGN KEY (fk_idioma) REFERENCES idioma (id_idioma),
    FOREIGN KEY (fk_estado) REFERENCES estado (id_estado)
);

CREATE TABLE IF NOT EXISTS categoria(
    id_categoria INT UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE IF NOT EXISTS tipo_usuario(
    id_tipo_usuario INT UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_tipo_usuario)
);

CREATE TABLE IF NOT EXISTS usuario(
    id_usuario INT UNSIGNED AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(30) NOT NULL,
    apellido VARCHAR(30),
    fk_tipo_usuario INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (fk_tipo_usuario) REFERENCES tipo_usuario (id_tipo_usuario)
);

CREATE TABLE IF NOT EXISTS libro_autor(
    fk_autor INT UNSIGNED NOT NULL,
    fk_libro INT UNSIGNED NOT NULL,
    FOREIGN KEY (fk_autor) REFERENCES autor (id_autor),
    FOREIGN KEY (fk_libro) REFERENCES libro (id_libro)
);

CREATE TABLE IF NOT EXISTS prestamo(
    id_prestamo INT UNSIGNED AUTO_INCREMENT NOT NULL,
    fk_copia INT UNSIGNED NOT NULL,
    fk_usuario INT UNSIGNED NOT NULL,
    fecha_prestamo DATE NOT NULL,
    fecha_entrega DATE,
    multa INT UNSIGNED,
    PRIMARY KEY (id_prestamo),
    FOREIGN KEY (fk_usuario) REFERENCES usuario (id_usuario),
    FOREIGN KEY (fk_copia) REFERENCES copia (id_copia)
);

CREATE TABLE IF NOT EXISTS libro_categoria(
    fk_libro INT UNSIGNED NOT NULL,
    fk_categoria INT UNSIGNED NOT NULL,
    FOREIGN KEY (fk_libro) REFERENCES libro (id_libro),
    FOREIGN KEY (fk_categoria) REFERENCES categoria (id_categoria)
);
