DROP PROCEDURE IF EXISTS sp_cobrar_multa;
DELIMITER ||
CREATE PROCEDURE sp_cobrar_multa
(
    _id_prestamo INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
    DECLARE _fecha DATE;
    DECLARE _dias_disponibles INT DEFAULT 0;
    DECLARE _dias_extra INT DEFAULT 0;
    DECLARE _dias_pasados INT DEFAULT 0;
    DECLARE _valor INT UNSIGNED;
    DECLARE _id_multa INT UNSIGNED;
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
            'No existe el préstamo con id ' || _id_prestamo
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Comprobar si el préstamo aún no se devuelve
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
            'Ese préstamo ya fue devuelto, no hay que considerar multa'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Obtener la fecha del préstamo
    SELECT
        fecha_prestamo
    INTO
        _fecha
    FROM
        prestamo
    WHERE
        id_prestamo = _id_prestamo;

    -- Calcular los días que han pasado desde el préstamo
    SELECT
        DATEDIFF(NOW(), _fecha) + 1
    INTO
        _dias_pasados;

    -- Si hay días de plazo extra los debemos añadir
    IF (
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
        -- Obtener el código del plazo extra para luego obtener los días extra
        SELECT
            fk_plazo_extra
        INTO
            _id_plazo_extra
        FROM
            prestamo
        WHERE
            id_prestamo = _id_prestamo;

        -- Obtener días extra
        SELECT
            dias_extra
        INTO
            _dias_extra
        FROM
            plazo_extra
        WHERE
            id_plazo_extra = _id_plazo_extra;

        -- Sumar días extra
        SET
            _dias_disponibles = _dias_disponibles + _dias_extra;
    END IF;

    -- Determinar el tipo de usuario
    IF
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
        ) = 1
    ) THEN
        -- Estudiante
        SET _dias_disponibles = _dias_disponibles + 7;
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
        SET
            _dias_disponibles = _dias_disponibles + 20;
    ELSE
        -- Nunca deberíamos llegar aquí, pero si pasa cerramos el proceso
        SELECT
            'Ese tipo de usuario no existe'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Comprobamos si ya pasaron los días de préstamo totales
    IF
    (
        (
            SELECT
                (_dias_pasados - _dias_disponibles)
        ) >= 1
    ) THEN
        SELECT
            (_dias_pasados - _dias_disponibles) * 1000
        INTO
            _valor;

        -- Verificar si ya existe la multa o no
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
                    fk_multa IS NULL
            ) = 1
        ) THEN

            -- Crear la multa y vincular
            INSERT INTO
                multa
                (
                    valor
                )
            VALUES
                (
                    _valor
                );

            SELECT
                LAST_INSERT_ID()
            INTO
                _id_multa;

            UPDATE
                prestamo
            SET
                fk_multa = _id_multa
            WHERE
                id_prestamo = _id_prestamo;

            -- Indicar registro de multa
            SELECT
                'Se registró una multa por $' || _valor
            AS
                'Mensaje';
        ELSE

            -- Actualizar la multa existente
            SELECT
                multa.id_multa
            INTO
                _id_multa
            FROM
                multa
            INNER JOIN
                prestamo
            ON
                multa.id_multa = prestamo.fk_multa
            WHERE
                prestamo.id_prestamo = _id_prestamo;

            UPDATE
                multa
            SET
                valor = _valor
            WHERE
                id_multa = _id_multa;

            -- Mensaje con nuevo valor de la multa
            SELECT
                'La multa ahora es de $' || _valor
            AS
                'Mensaje';
        END IF;

    ELSE
        -- Aún no se debe cobrar multa
        IF
        (
            (
                SELECT
                    (- (_dias_pasados - _dias_disponibles)) + 1
            ) = 1
        ) THEN
            SELECT
                'Aún queda un día de préstamo'
            AS
                'Mensaje';
        ELSE
            SELECT
                'Aún quedan ' || (- (_dias_pasados - _dias_disponibles)) + 1 || ' días de préstamo'
            AS
                'Mensaje';
        END IF;
    END IF;

END ||
DELIMITER ;
