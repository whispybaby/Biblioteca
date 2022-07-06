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
    DECLARE _multas_sin_pagar INT UNSIGNED;
    DECLARE _prestamos_sin_devolver INT UNSIGNED;

    -- Comprobar si existe la copia
    IF
    (
        (
            SELECT
                COUNT(*)
            FROM
                copia
            WHERE
                id_copia = _id_copia
        ) = 0
    ) THEN
        SELECT
            CONCAT('No existe la copia con id ', _id_copia)
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

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
            CONCAT('La copia con id ', CONCAT(_id_copia, ' ya está en préstamo'))
        AS
            'Mensaje';
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
                CONCAT('La copia con id ', CONCAT(_id_copia, ' es de un libro que ya solicitó'))
            AS
                'Mensaje';
            LEAVE PROCEDIMIENTO;
        END IF;
        SET
            _idx = _idx + 1;
    END WHILE;

    -- Para volver a usarlo después
    SET
        _idx = 0;

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
            CONCAT('No hay ningún usuario con id ', _id_usuario)
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Comprobar si hay multas del usuario
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
            AND
                fk_multa IS NOT NULL
        ) > 0
    ) THEN
        -- Obtener multas sin pagar
        SELECT
            COUNT(*)
        INTO
            _multas_sin_pagar
        FROM
            prestamo
        INNER JOIN
            multa
        ON
            prestamo.fk_multa = multa.id_multa
        WHERE
            fk_usuario = _id_usuario
        AND
            prestamo.fecha_entrega IS NULL
        AND
            (multa.valor - multa.valor_cancelado) > 0;

        -- Terminar si hay multas sin pagar
        IF
        (
            _multas_sin_pagar = 1
        ) THEN
            SELECT
                'No se puede realizar el préstamo, el usuario cuenta con 1 multa sin pagar'
            AS
                'Mensaje';
            LEAVE PROCEDIMIENTO;
        ELSEIF
        (
            _multas_sin_pagar > 1
        ) THEN
            SELECT
                CONCAT('No se puede realizar el préstamo, el usuario cuenta con ', CONCAT(_multas_sin_pagar, ' multas sin pagar'))
            AS
                'Mensaje';
            LEAVE PROCEDIMIENTO;
        ELSE
            -- Obtener préstamos pagados pero sin devolver
            SELECT
                COUNT(*)
            INTO
                _prestamos_sin_devolver
            FROM
                prestamo
            INNER JOIN
                multa
            ON
                prestamo.fk_multa = multa.id_multa
            WHERE
                fk_usuario = 4
            AND
                prestamo.fecha_entrega IS NULL
            AND
                (multa.valor - multa.valor_cancelado) = 0;

            -- Comprobar si hay préstamos retrasados
            IF
            (
                _prestamos_sin_devolver = 1
            ) THEN
                SELECT
                    'El usuario cuenta con 1 préstamo sin devolver'
                AS
                    'Mensaje';
                LEAVE PROCEDIMIENTO;
            ELSEIF
            (
                _prestamos_sin_devolver > 1
            ) THEN
                SELECT
                    CONCAT('El usuario cuenta con ', CONCAT(_prestamos_sin_devolver, ' préstamos sin devolver'))
                AS
                    'Mensaje';
                LEAVE PROCEDIMIENTO;
            END IF;
        END IF;
    END IF;

    -- Determinar tipo usuario
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
                'Un estudiante no puede tener más de 4 préstamos'
            AS
                'Mensaje';
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

        SELECT
            CONCAT('Se prestó la copia con id ', CONCAT(_id_copia, CONCAT(' al usuario con id ', _id_usuario)))
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;

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

        SELECT
            CONCAT('Se prestó la copia con id ', CONCAT(_id_copia, CONCAT(' al usuario con id ', _id_usuario)))
        AS
            'Mensaje';

    ELSE
        SELECT
            'El tipo de usuario no es correcto'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;
END ||
DELIMITER ;
