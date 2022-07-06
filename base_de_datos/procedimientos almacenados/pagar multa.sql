DROP PROCEDURE IF EXISTS sp_pagar_multa;
DELIMITER ||
CREATE PROCEDURE sp_pagar_multa
(
    _id_prestamo INT UNSIGNED,
    _monto_abono INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
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
                fk_multa IS NULL
        ) = 1
    ) THEN
        SELECT
            'No hay ninguna multa que pagar'
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

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

    -- Restar monto abono
    IF
    (
        _monto_abono >= _valor_restante
    ) THEN
        -- Pagamos lo restante de la multa
        UPDATE
            multa
        SET
            valor_cancelado = valor_cancelado + _valor_restante
        WHERE
            id_multa = _id_multa;

        -- Vuelto restante
        SELECT
            CONCAT('Multa cancelada, su vuelto es $', _monto_abono - _valor_restante)
        AS
            'Mensaje';
    ELSE
        -- Abonamos el monto al pago de la multa
        UPDATE
            multa
        SET
            valor_cancelado = valor_cancelado + _monto_abono
        WHERE
            id_multa = _id_multa;

        -- Indicamos cuanto falta por pagar
        SELECT
            CONCAT('Abono realizado, falta pagar $', _valor_restante - _monto_abono)
        AS
            'Mensaje';
    END IF;

END ||
DELIMITER ;
