DELIMITER ||
CREATE PROCEDURE sp_devolver_copia(
    IN _id_copia INT UNSIGNED,
    IN _id_prestamo INT UNSIGNED
)
PROCEDIMIENTO:BEGIN
UPDATE prestamo SET fecha_entrega = DATE(NOW()) WHERE id_prestamo = _id_prestamo;
UPDATE copia SET fk_estado = 1 WHERE id_copia = _id_copia;
END ||
DELIMITER ;
