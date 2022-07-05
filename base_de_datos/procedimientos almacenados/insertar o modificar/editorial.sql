DROP PROCEDURE IF EXISTS sp_insertar_modificar_editorial;
DELIMITER ||
CREATE PROCEDURE sp_insertar_modificar_editorial
(
    _id_editorial INT UNSIGNED,
    _nombre VARCHAR(20),
    _correo VARCHAR(45),
    _telefono VARCHAR(25),
    _fecha_fundacion DATE
)
PROCEDIMIENTO:BEGIN
IF
(
    (
        SELECT
            COUNT(*)
        FROM
            editorial
        WHERE
            id_editorial = _id_editorial
    ) = 0
) THEN
    INSERT INTO
        editorial
        (
            nombre,
            correo,
            telefono,
            fecha_fundacion
        )
    VALUES
        (
            _nombre,
            _correo,
            _telefono,
            _fecha_fundacion
        );
ELSE
    UPDATE
        editorial
    SET
        nombre = _nombre,
        correo = _correo,
        telefono = _telefono,
        fecha_fundacion = _fecha_fundacion
    WHERE
        id_editorial = _id_editorial;
END IF;
END ||
DELIMITER ;
