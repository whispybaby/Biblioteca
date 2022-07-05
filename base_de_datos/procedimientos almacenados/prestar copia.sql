DROP PROCEDURE IF EXISTS sp_prestar_copia;
DELIMITER ||
CREATE PROCEDURE sp_prestar_copia(
    _id_copia INT UNSIGNED,
    _id_usuario INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
    DECLARE _idx INT UNSIGNED DEFAULT 0;
    DECLARE _id_libro INT UNSIGNED;
    DECLARE _total_prestamos_usuario INT UNSIGNED;

    -- No se puede prestar la misma copia
    IF
    (
        (
            SELECT
                COUNT(*)
            FROM
                copia
            WHERE
                fk_estado = 2
            AND
                id_copia = _id_copia
        ) >= 1
    ) THEN
        SELECT
            'Esa copia ya está en préstamo'
        AS
            'Respuesta';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- No se puede pedir el mismo libro, aunque sean copias diferentes
    SELECT
        libro.id_libro
    INTO
        _id_libro
    FROM
        libro
    INNER JOIN
        copia
    ON
        libro.id_libro = copia.fk_libro
    WHERE
        copia.id_copia = _id_copia;

    -- Para saber cuantas veces repetir
    SELECT
        COUNT(libro.id_libro)
    INTO
        _total_prestamos_usuario
    FROM
        libro
    INNER JOIN
        copia
    ON
        libro.id_libro = copia.fk_libro
    INNER JOIN
        prestamo
    ON
        copia.id_copia = prestamo.fk_copia
    WHERE
        prestamo.fecha_entrega IS NULL
    AND
        prestamo.fk_usuario = _id_usuario;

    -- Comprobar para cada prestamo del usuario
    WHILE
        _idx < _total_prestamos_usuario
    DO
        IF
        (
            (
                SELECT
                    libro.id_libro
                FROM
                    libro
                INNER JOIN
                    copia
                ON
                    libro.id_libro = copia.fk_libro
                INNER JOIN
                    prestamo
                ON
                    copia.id_copia = prestamo.fk_copia
                WHERE
                    prestamo.fecha_entrega IS NULL
                AND
                    prestamo.fk_usuario = _id_usuario
                LIMIT
                    _idx, 1
            ) = _id_libro
        )
        THEN
            SELECT
                'La copia es de un libro ya pedido'
            AS
                'Mensaje';
            LEAVE PROCEDIMIENTO;
        END IF;
        SET
            _idx = _idx + 1;
    END WHILE;

    -- Debe ser un usuario válido
    IF
    (
        (
            SELECT
                COUNT(*)
            FROM
                usuario
            WHERE
                id_usuario = _id_usuario
        ) != 1
    ) THEN
        SELECT
            'No existe el usuario'
        AS
            'Respuesta';

    ELSE
        IF
        (
            (
                SELECT
                    fk_tipo_usuario
                FROM
                    usuario
                WHERE
                    id_usuario = _id_usuario
            ) = 1
        ) THEN

            -- No puede tener más de 4 préstamos
            IF
            (
                (
                    SELECT
                        COUNT(*)
                    FROM
                        prestamo
                    WHERE
                        fk_usuario = _id_usuario
                    AND
                        fecha_entrega IS NULL
                ) >= 4
            ) THEN
                SELECT
                    'Un estudiante no puede pedir más de 4 libros'
                AS
                    'Respuesta';
                LEAVE PROCEDIMIENTO;
            END IF;
            -- Ahora podemos insertar
            INSERT INTO
                prestamo
                    (
                        fk_copia,
                        fk_usuario,
                        fecha_prestamo
                    )
                VALUES
                    (
                        _id_copia,
                        _id_usuario,
                        DATE(NOW())
                    );

            UPDATE
                copia
            SET
                fk_estado = 2
            WHERE
                id_copia = _id_copia;

        ELSEIF (
            (
                SELECT
                    fk_tipo_usuario
                FROM
                    usuario
                WHERE
                    id_usuario = _id_usuario
            ) = 2
        ) THEN
            -- Ahora podemos insertar
            INSERT INTO
                prestamo
                (
                    fk_copia,
                    fk_usuario,
                    fecha_prestamo
                )
            VALUES
                (
                    _id_copia,
                    _id_usuario,
                    DATE(NOW())
                );

            UPDATE
                copia
            SET
                fk_estado = 2
            WHERE
                id_copia = _id_copia;

        ELSE
            SELECT
                'El tipo de usuario no es correcto'
            AS
                'Respuesta';
        END IF;

    END IF;
END ||
DELIMITER ;
