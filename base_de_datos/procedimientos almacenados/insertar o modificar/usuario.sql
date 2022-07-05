DROP PROCEDURE IF EXISTS sp_insertar_modificar_usuario;
DELIMITER ||
CREATE PROCEDURE sp_insertar_modificar_usuario
(
    _id_usuario INT UNSIGNED,
    _nombre VARCHAR(30),
    _apellido VARCHAR(30),
    _fk_tipo_usuario INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
IF
(
    (
        SELECT
            COUNT(*)
        FROM
            usuario
        WHERE
            id_usuario = _id_usuario
    ) = 0
) THEN
    INSERT INTO
        usuario
        (
            nombre,
            apellido,
            fk_tipo_usuario
        )
    VALUES
        (
            _nombre,
            _apellido,
            _fk_tipo_usuario
        );
ELSE
    UPDATE
        usuario
    SET
        nombre = _nombre,
        apellido = _apellido,
        fk_tipo_usuario = _fk_tipo_usuario
    WHERE
        id_usuario = _id_usuario;
END IF;
END ||
DELIMITER ;
