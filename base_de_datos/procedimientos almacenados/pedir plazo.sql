DROP PROCEDURE IF EXISTS sp_plazo_extra;
DELIMITER ||
CREATE PROCEDURE sp_plazo_extra
(
    _id_prestamo INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
    DECLARE _id_usuario INT UNSIGNED;
    DECLARE _id_plazo_extra INT UNSIGNED;

    -- Verificar que existe el préstamo
    IF
    (
        (
            SELECT
                COUNT(*)
            FROM
                prestamo
            WHERE
                id_prestamo = _id_prestamo
        ) = 0
    ) THEN
        SELECT
            CONCAT('No existe el préstamo con id ', _id_prestamo)
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Obtener el id de usuario asociado al préstamo
    SELECT
        fk_usuario
    INTO
        _id_usuario
    FROM
        prestamo
    WHERE
        id_prestamo = _id_prestamo;

    -- Comprobar si ya se entregó la copia asociada al préstamo
    IF
    (
        (
            SELECT
                COUNT(*)
            FROM
                prestamo
            WHERE
                id_prestamo = _id_prestamo
            AND
                fecha_entrega IS NOT NULL
        ) = 1
    ) THEN
        SELECT
            'Esa copia ya fue devuelta'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Comprobar las multas del usuario
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
        SELECT
            'El usuario cuenta con multas, no puede pedir plazo extra'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Determinar el tipo de usuario
    IF
    (
        (
            -- TODO: simplificar esto, ya tenemos el id usuario y no hace falta
            -- más de un join
            SELECT
                tipo_usuario.id_tipo_usuario
            FROM
                tipo_usuario
            INNER JOIN
                usuario
            ON
                tipo_usuario.id_tipo_usuario = usuario.fk_tipo_usuario
            INNER JOIN
                prestamo
            ON
                usuario.id_usuario = prestamo.fk_usuario
            WHERE
                prestamo.id_prestamo = _id_prestamo
        ) = 1
    ) THEN
        -- Estudiante
        IF
        (
            -- Determinar cantidad de plazos pedidos en los libros sin devolver
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
                    fk_plazo_extra IS NOT NULL
            ) >= 1
        ) THEN
            SELECT
                'El estudiante ya tiene un plazo extra'
            AS
                'Mensaje';
            LEAVE PROCEDIMIENTO;
        END IF;

        -- Ahora podemos realizar el plazo extra
        INSERT INTO
            plazo_extra
            (
                dias_extra,
                veces_extendido
            )
        VALUES
            (
                3,
                1
            );

        SELECT
            LAST_INSERT_ID()
        INTO
            _id_plazo_extra;

        UPDATE
            prestamo
        SET
            fk_plazo_extra = _id_plazo_extra
        WHERE
            id_prestamo = _id_prestamo;

    ELSEIF
        (
            (
                SELECT
                    tipo_usuario.id_tipo_usuario
                FROM
                    tipo_usuario
                INNER JOIN
                    usuario
                ON
                    tipo_usuario.id_tipo_usuario = usuario.fk_tipo_usuario
                INNER JOIN
                    prestamo
                ON
                    usuario.id_usuario = prestamo.fk_usuario
                WHERE
                    prestamo.id_prestamo = _id_prestamo
            ) = 2
        ) THEN

        -- Docente
        IF
        (
            (
                SELECT
                    COUNT(*)
                FROM
                    prestamo
                WHERE
                    id_prestamo = _id_prestamo
                AND
                    fk_plazo_extra IS NOT NULL
            ) = 1
        ) THEN

            -- Actualizar el plazo extra
            SELECT
                fk_plazo_extra
            INTO
                _id_plazo_extra
            FROM
                prestamo
            WHERE
                id_prestamo = _id_prestamo;

            IF
            (
                (
                    SELECT
                        veces_extendido
                    FROM
                        plazo_extra
                    WHERE
                        id_plazo_extra = _id_plazo_extra
                ) >= 3
            ) THEN
                SELECT
                    'No se puede renovar el préstamo más de 3 veces'
                AS
                    'Mensaje';
                LEAVE PROCEDIMIENTO;
            END IF;

            UPDATE
                plazo_extra
            SET
                dias_extra = dias_extra + 3,
                veces_extendido = veces_extendido + 1
            WHERE
                id_plazo_extra = _id_plazo_extra;

        ELSE
            -- Crear el plazo extra
            INSERT INTO
                plazo_extra
                (
                    dias_extra,
                    veces_extendido
                )
            VALUES
                (
                    3,
                    1
                );

            SELECT
                LAST_INSERT_ID()
            INTO
                _id_plazo_extra;

            UPDATE
                prestamo
            SET
                fk_plazo_extra = _id_plazo_extra
            WHERE
                id_prestamo = _id_prestamo;

        END IF;
    ELSE
        -- Nunca deberíamos llegar aquí, pero si pasa cerramos el proceso
        SELECT
            'Ese tipo de usuario no existe'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

END ||
DELIMITER ;
