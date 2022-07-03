DELIMITER ||
CREATE PROCEDURE sp_insertar_modificar_libro(
    IN _id_libro INT UNSIGNED,
    IN _titulo VARCHAR(30),
    IN _fecha_de_publicacion DATE,
    IN _fk_editorial INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
IF (
    (
        SELECT COUNT(*)
        FROM libro
        WHERE id_libro = _id_libro
    ) = 0
) THEN
    INSERT INTO libro(
        titulo,
        fecha_de_publicacion,
        fk_editorial)
    VALUES (
        _titulo,
        _fecha_de_publicacion,
        _fk_editorial
    );
ELSE
    UPDATE libro
    SET titulo = _titulo,
        fecha_de_publicacion = _fecha_de_publicacion,
        fk_editorial = _fk_editorial
    WHERE id_libro = _id_libro;
END IF;
END ||
DELIMITER ;
