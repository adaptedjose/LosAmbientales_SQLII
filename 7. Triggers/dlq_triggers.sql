-- In this document you will find the SQL code to execute triggers from the tables of the database.

-- On the bottom of this file you will find the necessary tables to execute the triggers.

-- 1. Trigger para registrar inserción de nuevas especies en áreas
DELIMITER //
CREATE TRIGGER trg_insert_especie_area
AFTER INSERT ON EspecieArea
FOR EACH ROW
BEGIN
    INSERT INTO log_inventario_especies (idEspecie, idArea, accion, numeroInventario, fecha)
    VALUES (NEW.idEspecie, NEW.idArea, 'INSERCIÓN', NEW.numeroInventarioEspecieArea, NOW());
END //
DELIMITER ;

-- 2. Trigger para actualizar inventario al modificar especies en áreas
DELIMITER //
CREATE TRIGGER trg_update_especie_area
AFTER UPDATE ON EspecieArea
FOR EACH ROW
BEGIN
    INSERT INTO log_inventario_especies (idEspecie, idArea, accion, numeroInventario, fecha)
    VALUES (NEW.idEspecie, NEW.idArea, 'ACTUALIZACIÓN', NEW.numeroInventarioEspecieArea, NOW());
END //
DELIMITER ;

-- 3. Trigger para registrar eliminación de especies en áreas
DELIMITER //
CREATE TRIGGER trg_delete_especie_area
AFTER DELETE ON EspecieArea
FOR EACH ROW
BEGIN
    INSERT INTO log_inventario_especies (idEspecie, idArea, accion, numeroInventario, fecha)
    VALUES (OLD.idEspecie, OLD.idArea, 'ELIMINACIÓN', OLD.numeroInventarioEspecieArea, NOW());
END //
DELIMITER ;

-- 4. Trigger para verificar consistencia antes de insertar en EspecieArea
DELIMITER //
CREATE TRIGGER trg_check_insert_especie_area
BEFORE INSERT ON EspecieArea
FOR EACH ROW
BEGIN
    IF NEW.numeroInventarioEspecieArea < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El número de inventario no puede ser negativo';
    END IF;
END //
DELIMITER ;

-- 5. Trigger para evitar duplicados en EspecieArea antes de insertar
DELIMITER //
CREATE TRIGGER trg_prevent_duplicate_especie_area
BEFORE INSERT ON EspecieArea
FOR EACH ROW
BEGIN
    DECLARE especie_count INT;
    SELECT COUNT(*) INTO especie_count
    FROM EspecieArea
    WHERE idEspecie = NEW.idEspecie AND idArea = NEW.idArea;
    IF especie_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La especie ya está registrada en esta área';
    END IF;
END //
DELIMITER ;

-- 6. Trigger para ajustar inventario al cambiar el área
DELIMITER //
CREATE TRIGGER trg_update_area_inventario
AFTER UPDATE ON area
FOR EACH ROW
BEGIN
    IF NEW.idParque != OLD.idParque THEN
        INSERT INTO log_inventario_especies (idEspecie, idArea, accion, numeroInventario, fecha)
        SELECT idEspecie, NEW.idArea, 'CAMBIO PARQUE', numeroInventarioEspecieArea, NOW()
        FROM EspecieArea
        WHERE idArea = OLD.idArea;
    END IF;
END //
DELIMITER ;

-- 7. Trigger para registrar eliminación de áreas
DELIMITER //
CREATE TRIGGER trg_delete_area_inventario
AFTER DELETE ON area
FOR EACH ROW
BEGIN
    INSERT INTO log_inventario_especies (idEspecie, idArea, accion, numeroInventario, fecha)
    SELECT idEspecie, OLD.idArea, 'ÁREA ELIMINADA', numeroInventarioEspecieArea, NOW()
    FROM EspecieArea
    WHERE idArea = OLD.idArea;
END //
DELIMITER ;

-- 8. Trigger para validar inventario antes de actualizar
DELIMITER //
CREATE TRIGGER trg_validate_update_especie_area
BEFORE UPDATE ON EspecieArea
FOR EACH ROW
BEGIN
    IF NEW.numeroInventarioEspecieArea < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El inventario no puede ser negativo al actualizar';
    END IF;
END //
DELIMITER ;

-- 9. Trigger para registrar inserción masiva en áreas
DELIMITER //
CREATE TRIGGER trg_bulk_insert_especie_area
AFTER INSERT ON EspecieArea
FOR EACH ROW
BEGIN
    INSERT INTO log_inventario_especies (idEspecie, idArea, accion, numeroInventario, fecha)
    VALUES (NEW.idEspecie, NEW.idArea, 'INSERCIÓN MASIVA', NEW.numeroInventarioEspecieArea, NOW());
END //
DELIMITER ;

-- 10. Trigger para actualizar inventario al crear un área nueva
DELIMITER //
CREATE TRIGGER trg_new_area_inventario
AFTER INSERT ON area
FOR EACH ROW
BEGIN
    INSERT INTO log_inventario_especies (idEspecie, idArea, accion, numeroInventario, fecha)
    VALUES (NULL, NEW.idArea, 'NUEVA ÁREA CREADA', 0, NOW());
END //
DELIMITER ;

-- 11. Trigger para registrar inserción de nuevo personal
DELIMITER //
CREATE TRIGGER trg_insert_personal
AFTER INSERT ON personal
FOR EACH ROW
BEGIN
    INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
    VALUES (NEW.cedulaPersonal, 'NUEVO EMPLEADO', NEW.sueldoPersonal, NOW());
END //
DELIMITER ;

-- 12. Trigger para registrar cambios salariales
DELIMITER //
CREATE TRIGGER trg_update_sueldo_personal
AFTER UPDATE ON personal
FOR EACH ROW
BEGIN
    IF NEW.sueldoPersonal != OLD.sueldoPersonal THEN
        INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
        VALUES (NEW.cedulaPersonal, 'CAMBIO SALARIAL', NEW.sueldoPersonal, NOW());
    END IF;
END //
DELIMITER ;

-- 13. Trigger para registrar eliminación de personal
DELIMITER //
CREATE TRIGGER trg_delete_personal
AFTER DELETE ON personal
FOR EACH ROW
BEGIN
    INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
    VALUES (OLD.cedulaPersonal, 'EMPLEADO ELIMINADO', OLD.sueldoPersonal, NOW());
END //
DELIMITER ;

-- 14. Trigger para validar sueldo antes de insertar
DELIMITER //
CREATE TRIGGER trg_validate_insert_sueldo
BEFORE INSERT ON personal
FOR EACH ROW
BEGIN
    IF NEW.sueldoPersonal <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El sueldo debe ser mayor a cero';
    END IF;
END //
DELIMITER ;

-- 15. Trigger para registrar cambio de tipo de personal
DELIMITER //
CREATE TRIGGER trg_update_tipo_personal
AFTER UPDATE ON personal
FOR EACH ROW
BEGIN
    IF NEW.tipoPersonal != OLD.tipoPersonal THEN
        INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
        VALUES (NEW.cedulaPersonal, 'CAMBIO TIPO PERSONAL', NEW.sueldoPersonal, NOW());
    END IF;
END //
DELIMITER ;

-- 16. Trigger para registrar nuevo teléfono del personal
DELIMITER //
CREATE TRIGGER trg_insert_telefono_personal
AFTER INSERT ON telefonoPersonal
FOR EACH ROW
BEGIN
    INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
    VALUES (NEW.cedulaPersonal, 'NUEVO TELÉFONO', NULL, NOW());
END //
DELIMITER ;

-- 17. Trigger para registrar eliminación de teléfono
DELIMITER //
CREATE TRIGGER trg_delete_telefono_personal
AFTER DELETE ON telefonoPersonal
FOR EACH ROW
BEGIN
    INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
    VALUES (OLD.cedulaPersonal, 'TELÉFONO ELIMINADO', NULL, NOW());
END //
DELIMITER ;

-- 18. Trigger para registrar asignación de personal de gestión
DELIMITER //
CREATE TRIGGER trg_insert_personal_gestion
AFTER INSERT ON personalGestion
FOR EACH ROW
BEGIN
    INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
    VALUES (NEW.cedulaPersonalGestion, 'ASIGNADO A GESTIÓN', NULL, NOW());
END //
DELIMITER ;

-- 19. Trigger para registrar eliminación de personal de gestión
DELIMITER //
CREATE TRIGGER trg_delete_personal_gestion
AFTER DELETE ON personalGestion
FOR EACH ROW
BEGIN
    INSERT INTO log_personal (cedulaPersonal, accion, sueldo, fecha)
    VALUES (OLD.cedulaPersonalGestion, 'RETIRADO DE GESTIÓN', NULL, NOW());
END //
DELIMITER ;

-- 20. Trigger para validar sueldo antes de actualizar
DELIMITER //
CREATE TRIGGER trg_validate_update_sueldo
BEFORE UPDATE ON personal
FOR EACH ROW
BEGIN
    IF NEW.sueldoPersonal <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El sueldo no puede ser menor o igual a cero al actualizar';
    END IF;
END //
DELIMITER ;

-- Tablas adicionales necesarias
CREATE TABLE log_inventario_especies (
    idLog INT PRIMARY KEY AUTO_INCREMENT,
    idEspecie INT,
    idArea INT,
    accion VARCHAR(50),
    numeroInventario INT,
    fecha DATETIME
);

CREATE TABLE log_personal (
    idLog INT PRIMARY KEY AUTO_INCREMENT,
    cedulaPersonal VARCHAR(20),
    accion VARCHAR(50),
    sueldo DECIMAL(10,2),
    fecha DATETIME
);