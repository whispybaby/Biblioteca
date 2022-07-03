DELIMITER ||
CREATE PROCEDURE sp_buscar_copia(
    IN _id_libro INT UNSIGNED
)
BEGIN
IF (
    (
        SELECT COUNT(libro.id_libro)
        FROM libro
        WHERE libro.id_libro = _id_libro
    ) != 1
)
THEN
    SELECT 'No existe el libro indicado' AS 'Respuesta';
ELSE
    IF (
        (
            SELECT COUNT(copia.id_copia)
            FROM libro INNER JOIN copia
            ON libro.id_libro = copia.fk_libro
            WHERE libro.id_libro = _id_libro
            AND copia.fk_estado = 1
        ) = 0
    )
    THEN
        SELECT 'No hay ninguna copia disponible del libro' AS 'Respuesta';
    ELSE
        SELECT copia.id_copia
        AS 'Copia disponible'
        FROM libro INNER JOIN copia
        ON libro.id_libro = copia.fk_libro
        WHERE libro.id_libro = _id_libro
        AND copia.fk_estado = 1
        LIMIT 1;
    END IF;
END IF;
END ||
DELIMITER ;
