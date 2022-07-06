DROP PROCEDURE IF EXISTS sp_buscar_copia;
DELIMITER ||
CREATE PROCEDURE sp_buscar_copia
(
    _id_libro INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
    DECLARE _id_copia INT UNSIGNED;

    -- Comprobar si existe el libro
    IF
    (
        (
            SELECT
                COUNT(*)
            FROM
                libro
            WHERE
                id_libro = _id_libro
        ) = 0
    ) THEN
        SELECT
            CONCAT('No existe ningún libro con id ', _id_libro)
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Ver si hay copias disponibles para prestar
    IF
    (
        (
            SELECT
                COUNT(*)
            FROM
                libro
            INNER JOIN
                copia
            ON
                libro.id_libro = copia.fk_libro
            WHERE
                libro.id_libro = _id_libro
            AND
                copia.fk_estado = 1
        ) = 0
    ) THEN
        SELECT
            CONCAT('No hay copias disponibles del libro con id ', _id_libro)
        AS
            'Mensaje';
        LEAVE PROCEDIMIENTO;
    END IF;

    -- Seleccionar una de las copias
    SELECT
        copia.id_copia
    INTO
        _id_copia
    FROM
        libro
    INNER JOIN
        copia
    ON
        libro.id_libro = copia.fk_libro
    WHERE
        libro.id_libro = _id_libro
    AND
        copia.fk_estado = 1
    LIMIT
        1;

    -- Indicar qué copia se puede prestar
    SELECT
        CONCAT('Está disponible la copia con id ', _id_copia)
    AS
        'Mensaje';
END ||
DELIMITER ;
