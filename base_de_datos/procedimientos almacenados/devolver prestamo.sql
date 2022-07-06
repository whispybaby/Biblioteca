DROP PROCEDURE IF EXISTS sp_devolver_prestamo;
DELIMITER $
CREATE PROCEDURE sp_devolver_prestamo
(
    _id_prestamo INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
    DECLARE _id_copia INT UNSIGNED;
    DECLARE _id_multa INT UNSIGNED;
    DECLARE _valor_restante INT UNSIGNED;

    -- Comprobar si el préstamo existe
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
            'No existe el préstamo indicado'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Comprobar que si el préstamo ya fue entregado
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
            'Ese préstamo ya fue devuelto'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Comprobar si hay multas
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
                fk_multa IS NOT NULL
        ) = 1
    ) THEN

       -- Obtener id de la multa asociada
        SELECT
            fk_multa
        INTO
            _id_multa
        FROM
            prestamo
        WHERE
            id_prestamo = _id_prestamo;

        -- Obtener el monto por pagar de la multa
        SELECT
            (valor - valor_cancelado)
        INTO
            _valor_restante
        FROM
            multa
        WHERE
            id_multa = _id_multa;

        -- Comprobar si la multa ha sido pagada o no
        IF
        (
            _valor_restante > 0
        ) THEN
            SELECT
                'No se puede devolver, falta pagar multa de $' || _valor_restante
            AS
                'Mensaje';
            LEAVE PROCEDIMIENTO;
        END IF;
    END IF;

    -- Obtener el id de la copia asociada al préstamo
    SELECT
        fk_copia
    INTO
        _id_copia
    FROM
        prestamo
    WHERE
        id_prestamo = _id_prestamo;

    -- Registrar el préstamo como devuelto
    UPDATE
        prestamo
    SET
        fecha_entrega = DATE(NOW())
    WHERE
        id_prestamo = _id_prestamo;

    -- Actualizar el estado de la copia para que se pueda volver a pedir
    UPDATE
        copia
    SET
        fk_estado = 1
    WHERE
        id_copia = _id_copia;

    SELECT
        'Se ha devuelto es préstamo con id ' || _id_prestamo
    AS
        'Mensaje';

END $
DELIMITER ;
