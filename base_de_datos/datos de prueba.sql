-- estado
INSERT INTO estado(nombre) VALUES
('Disponible'),
('En préstamo');

-- tipo_usuario
INSERT INTO tipo_usuario(nombre) VALUES
('Estudiante'),
('Docente');

-- usuario
INSERT INTO usuario(nombre, apellido, fk_tipo_usuario) VALUES
('Gabriel', 'Barrientos', 1),
('Charlotte', 'Rodriguez', 1),
('Patricio', 'Polanco', 2),
('Jonathan', 'Toledo', 2);

-- editorial
INSERT INTO editorial(nombre, correo, telefono) VALUES
('Macmillan', 'press.inquiries@macmillan.com', NULL),
('Santillana', 'contacto@tiendasantillana.cl', '+56229437400'),
('Zigzag', 'contacto@zigzag.cl', NULL),
('Salamandra', NULL, NULL),
('Siruela', NULL, NULL),
('Tricahue', NULL, NULL);

-- idioma
INSERT INTO idioma(nombre) VALUES
('Inglés'),
('Español'),
('Alemán'),
('Francés'),
('Portugués'),
('Chino'),
('Sueco');

-- libro
INSERT INTO libro(titulo, fecha_de_publicacion, fk_editorial) VALUES
('El ladrón del rayo', '2005-07-01', 4),
('El mundo de sofía', '1991-12-05', 5),
('Pregúntale a Alicia', '1971-03-05', 3),
('El jardín secreto', '1911-00-00', 6),
('Colmillo blanco', '1906-00-00', 3);

-- autor
INSERT INTO autor(nombre, apellido) VALUES
('Frances', 'Hodgson Burnett'),
('Jack', 'London'),
('Anónimo', NULL),
('Jostein', 'Gaarder'),
('Rick', 'Riordan');

-- categoria
INSERT INTO categoria(nombre) VALUES
('Mitología griega'),
('Fantasía'),
('Ficción'),
('Novela'),
('Filosofía'),
('Ficción adulto joven'),
('Literatura infantil'),
('Ficción de aventuras');

-- libro_autor
INSERT INTO libro_autor(fk_autor, fk_libro) VALUES
(1, 4),
(2, 5),
(3, 3),
(4, 2),
(5, 1);

-- libro_categoria
INSERT INTO libro_categoria(fk_libro, fk_categoria) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(2, 4),
(2, 5),
(3, 4),
(3, 6),
(4, 3),
(4, 7),
(5, 4),
(5, 8);

-- copia
INSERT INTO copia(fk_libro, fk_idioma, fk_estado) VALUES
(1, 2, 1),
(1, 2, 1),
(1, 2, 1),
(2, 2, 1),
(2, 2, 1),
(2, 2, 1),
(3, 2, 1),
(3, 2, 1),
(4, 2, 1),
(5, 2, 1),
(5, 2, 1),
(5, 2, 1),
(5, 2, 1);
