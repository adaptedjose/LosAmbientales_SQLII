-- In this document you will find the SQL code to execute data procedures from the tables of the database.

DELIMITER //

-- 1. Registrar un nuevo parque
CREATE PROCEDURE RegistrarParque(
    IN p_nombreParque VARCHAR(100),
    IN p_fechaDeclaracion DATE
)
BEGIN
    IF EXISTS (SELECT 1 FROM parque WHERE nombreParque = p_nombreParque) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El parque ya existe en la base de datos.';
    ELSE
        INSERT INTO parque (nombreParque, fechaDeclaracionParque)
        VALUES (p_nombreParque, p_fechaDeclaracion);
        SELECT 'Parque registrado exitosamente.' AS Mensaje;
    END IF;
END //

-- 2. Actualizar datos de un parque
CREATE PROCEDURE ActualizarParque(
    IN p_idParque INT,
    IN p_nombreParque VARCHAR(100),
    IN p_fechaDeclaracion DATE
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM parque WHERE idParque = p_idParque) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El parque no existe.';
    ELSE
        UPDATE parque 
        SET nombreParque = p_nombreParque, 
            fechaDeclaracionParque = p_fechaDeclaracion
        WHERE idParque = p_idParque;
        SELECT 'Parque actualizado correctamente.' AS Mensaje;
    END IF;
END //

-- 3. Registrar una nueva área
CREATE PROCEDURE RegistrarArea(
    IN p_nombreArea VARCHAR(100),
    IN p_extensionArea DECIMAL(10,2),
    IN p_idParque INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM parque WHERE idParque = p_idParque) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El parque especificado no existe.';
    ELSE
        INSERT INTO area (nombreArea, extensionArea, idParque)
        VALUES (p_nombreArea, p_extensionArea, p_idParque);
        SELECT 'Área registrada con éxito.' AS Mensaje;
    END IF;
END //

-- 4. Actualizar datos de un área
CREATE PROCEDURE ActualizarArea(
    IN p_idArea INT,
    IN p_nombreArea VARCHAR(100),
    IN p_extensionArea DECIMAL(10,2)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM area WHERE idArea = p_idArea) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El área no existe.';
    ELSE
        UPDATE area 
        SET nombreArea = p_nombreArea, 
            extensionArea = p_extensionArea
        WHERE idArea = p_idArea;
        SELECT 'Área actualizada exitosamente.' AS Mensaje;
    END IF;
END //

-- 5. Registrar una nueva especie
CREATE PROCEDURE RegistrarEspecie(
    IN p_denominacionCientifica VARCHAR(100),
    IN p_denominacionVulgar VARCHAR(100),
    IN p_tipo ENUM('vegetal', 'animal', 'mineral')
)
BEGIN
    IF EXISTS (SELECT 1 FROM especie WHERE denominacionCientificaEspecie = p_denominacionCientifica) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La especie ya está registrada.';
    ELSE
        INSERT INTO especie (denominacionCientificaEspecie, denominacionVulgarEspecie, tipo)
        VALUES (p_denominacionCientifica, p_denominacionVulgar, p_tipo);
        SELECT 'Especie registrada con éxito.' AS Mensaje;
    END IF;
END //

-- 6. Asociar especie a un área
CREATE PROCEDURE AsociarEspecieArea(
    IN p_idEspecie INT,
    IN p_idArea INT,
    IN p_numeroInventario INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM especie WHERE idEspecie = p_idEspecie) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La especie no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM area WHERE idArea = p_idArea) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El área no existe.';
    ELSE
        INSERT INTO EspecieArea (idEspecie, idArea, numeroInventarioEspecieArea)
        VALUES (p_idEspecie, p_idArea, p_numeroInventario);
        SELECT 'Especie asociada al área correctamente.' AS Mensaje;
    END IF;
END //

-- 7. Registrar un nuevo visitante
CREATE PROCEDURE RegistrarVisitante(
    IN p_cedulaVisitante VARCHAR(20),
    IN p_nombreVisitante VARCHAR(100),
    IN p_direccionVisitante VARCHAR(200),
    IN p_profesionVisitante VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM visitante WHERE cedulaVisitante = p_cedulaVisitante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El visitante ya está registrado.';
    ELSE
        INSERT INTO visitante (cedulaVisitante, nombreVisitante, direccionVisitante, profesionVisitante)
        VALUES (p_cedulaVisitante, p_nombreVisitante, p_direccionVisitante, p_profesionVisitante);
        SELECT 'Visitante registrado exitosamente.' AS Mensaje;
    END IF;
END //

-- 8. Asignar alojamiento a un visitante
CREATE PROCEDURE AsignarAlojamiento(
    IN p_cedulaVisitante VARCHAR(20),
    IN p_idAlojamiento INT,
    IN p_fechaEntrada DATE,
    IN p_fechaSalida DATE
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM visitante WHERE cedulaVisitante = p_cedulaVisitante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El visitante no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM alojamiento WHERE idAlojamiento = p_idAlojamiento) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El alojamiento no existe.';
    ELSE
        INSERT INTO reservaAlojamiento (cedulaVisitante, idAlojamiento, fechaEntradaReservaAlojamiento, fechaSalidaReservaAlojamiento)
        VALUES (p_cedulaVisitante, p_idAlojamiento, p_fechaEntrada, p_fechaSalida);
        SELECT 'Alojamiento asignado correctamente.' AS Mensaje;
    END IF;
END //

-- 9. Registrar visita de un visitante a un parque
CREATE PROCEDURE RegistrarVisita(
    IN p_cedulaVisitante VARCHAR(20),
    IN p_idEntrada INT,
    IN p_cedulaPersonalGestion VARCHAR(20),
    IN p_fechaRegistro DATETIME
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM visitante WHERE cedulaVisitante = p_cedulaVisitante) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El visitante no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM entrada WHERE idEntrada = p_idEntrada) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La entrada no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM personalGestion WHERE cedulaPersonalGestion = p_cedulaPersonalGestion) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El personal de gestión no existe.';
    ELSE
        INSERT INTO registroVisita (cedulaVisitante, idEntrada, cedulaPersonalGestion, fechaRegistroVisita)
        VALUES (p_cedulaVisitante, p_idEntrada, p_cedulaPersonalGestion, p_fechaRegistro);
        SELECT 'Visita registrada con éxito.' AS Mensaje;
    END IF;
END //

-- 10. Asignar personal de vigilancia a un área
CREATE PROCEDURE AsignarVigilanciaArea(
    IN p_cedulaPersonal VARCHAR(20),
    IN p_idArea INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM personal WHERE cedulaPersonal = p_cedulaPersonal AND tipoPersonal = '002') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El personal no existe o no es vigilante.';
    ELSEIF NOT EXISTS (SELECT 1 FROM area WHERE idArea = p_idArea) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El área no existe.';
    ELSE
        INSERT INTO vigilanciaArea (cedulaPersonal, idArea)
        VALUES (p_cedulaPersonal, p_idArea);
        SELECT 'Vigilante asignado al área correctamente.' AS Mensaje;
    END IF;
END //

-- 11. Asignar personal de conservación a un área
CREATE PROCEDURE AsignarConservacionArea(
    IN p_cedulaPersonal VARCHAR(20),
    IN p_idArea INT,
    IN p_especialidad VARCHAR(100)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM personal WHERE cedulaPersonal = p_cedulaPersonal AND tipoPersonal = '003') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El personal no existe o no es de conservación.';
    ELSEIF NOT EXISTS (SELECT 1 FROM area WHERE idArea = p_idArea) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El área no existe.';
    ELSE
        INSERT INTO conservacionArea (cedulaPersonal, idArea, especialidadConservacionArea)
        VALUES (p_cedulaPersonal, p_idArea, p_especialidad);
        SELECT 'Personal de conservación asignado correctamente.' AS Mensaje;
    END IF;
END //

-- 12. Asignar vehículo a un vigilante
CREATE PROCEDURE AsignarVehiculoVigilante(
    IN p_cedulaPersonal VARCHAR(20),
    IN p_idVehiculo INT,
    IN p_fechaAsignacion DATE
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM personal WHERE cedulaPersonal = p_cedulaPersonal AND tipoPersonal = '002') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El personal no existe o no es vigilante.';
    ELSEIF NOT EXISTS (SELECT 1 FROM vehiculo WHERE idVehiculo = p_idVehiculo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El vehículo no existe.';
    ELSE
        INSERT INTO vehiculoVigilante (cedulaPersonal, idVehiculo, fechaAsignacionVehiculoVisitante)
        VALUES (p_cedulaPersonal, p_idVehiculo, p_fechaAsignacion);
        SELECT 'Vehículo asignado al vigilante correctamente.' AS Mensaje;
    END IF;
END //

-- 13. Registrar un nuevo proyecto de investigación
CREATE PROCEDURE RegistrarProyectoInvestigacion(
    IN p_nombreProyecto VARCHAR(100),
    IN p_presupuesto DECIMAL(15,2),
    IN p_fechaInicio DATE,
    IN p_fechaFin DATE
)
BEGIN
    INSERT INTO proyectoInvestigacion (nombreProyectoInvestigacion, presupuestoProyectoInvestigacion, fechaInicioProyectoInvestigacion, fechaFinProyectoInvestigacion)
    VALUES (p_nombreProyecto, p_presupuesto, p_fechaInicio, p_fechaFin);
    SELECT 'Proyecto de investigación registrado con éxito.' AS Mensaje;
END //

-- 14. Asignar investigador a un proyecto
CREATE PROCEDURE AsignarInvestigadorProyecto(
    IN p_cedulaPersonal VARCHAR(20),
    IN p_idProyectoInvestigacion INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM personal WHERE cedulaPersonal = p_cedulaPersonal AND tipoPersonal = '004') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El personal no existe o no es investigador.';
    ELSEIF NOT EXISTS (SELECT 1 FROM proyectoInvestigacion WHERE idProyectoInvestigacion = p_idProyectoInvestigacion) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proyecto no existe.';
    ELSE
        INSERT INTO investigadorProyecto (cedulaPersonal, idProyectoInvestigacion)
        VALUES (p_cedulaPersonal, p_idProyectoInvestigacion);
        SELECT 'Investigador asignado al proyecto correctamente.' AS Mensaje;
    END IF;
END //

-- 15. Asociar especie a un proyecto
CREATE PROCEDURE AsociarEspecieProyecto(
    IN p_idEspecie INT,
    IN p_idProyectoInvestigacion INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM especie WHERE idEspecie = p_idEspecie) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La especie no existe.';
    ELSEIF NOT EXISTS (SELECT 1 FROM proyectoInvestigacion WHERE idProyectoInvestigacion = p_idProyectoInvestigacion) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proyecto no existe.';
    ELSE
        INSERT INTO EspecieProyecto (idEspecie, idProyectoInvestigacion)
        VALUES (p_idEspecie, p_idProyectoInvestigacion);
        SELECT 'Especie asociada al proyecto correctamente.' AS Mensaje;
    END IF;
END //

-- 16. Actualizar presupuesto de un proyecto
CREATE PROCEDURE ActualizarPresupuestoProyecto(
    IN p_idProyectoInvestigacion INT,
    IN p_nuevoPresupuesto DECIMAL(15,2)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyectoInvestigacion WHERE idProyectoInvestigacion = p_idProyectoInvestigacion) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El proyecto no existe.';
    ELSE
        UPDATE proyectoInvestigacion 
        SET presupuestoProyectoInvestigacion = p_nuevoPresupuesto
        WHERE idProyectoInvestigacion = p_idProyectoInvestigacion;
        SELECT 'Presupuesto actualizado correctamente.' AS Mensaje;
    END IF;
END //

-- 17. Calcular total de presupuesto por parque
CREATE PROCEDURE CalcularPresupuestoPorParque(
    IN p_idParque INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM parque WHERE idParque = p_idParque) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El parque no existe.';
    ELSE
        SELECT p.nombreParque, SUM(pi.presupuestoProyectoInvestigacion) AS TotalPresupuesto
        FROM parque p
        JOIN area a ON p.idParque = a.idParque
        JOIN EspecieArea ea ON a.idArea = ea.idArea
        JOIN EspecieProyecto ep ON ea.idEspecie = ep.idEspecie
        JOIN proyectoInvestigacion pi ON ep.idProyectoInvestigacion = pi.idProyectoInvestigacion
        WHERE p.idParque = p_idParque
        GROUP BY p.nombreParque;
    END IF;
END //

-- 18. Contar visitantes por parque
CREATE PROCEDURE ContarVisitantesPorParque(
    IN p_idParque INT,
    IN p_fechaInicio DATE,
    IN p_fechaFin DATE
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM parque WHERE idParque = p_idParque) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El parque no existe.';
    ELSE
        SELECT p.nombreParque, COUNT(rv.cedulaVisitante) AS TotalVisitantes
        FROM parque p
        JOIN entrada e ON p.idParque = e.idParque
        JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
        WHERE p.idParque = p_idParque
        AND rv.fechaRegistroVisita BETWEEN p_fechaInicio AND p_fechaFin
        GROUP BY p.nombreParque;
    END IF;
END //

-- 19. Listar personal asignado a un área
CREATE PROCEDURE ListarPersonalArea(
    IN p_idArea INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM area WHERE idArea = p_idArea) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El área no existe.';
    ELSE
        SELECT a.nombreArea, p.cedulaPersonal, p.nombrePersonal, p.tipoPersonal,
               IFNULL(ca.especialidadConservacionArea, 'Vigilancia') AS Especialidad
        FROM area a
        LEFT JOIN vigilanciaArea va ON a.idArea = va.idArea
        LEFT JOIN conservacionArea ca ON a.idArea = ca.idArea
        LEFT JOIN personal p ON p.cedulaPersonal = va.cedulaPersonal OR p.cedulaPersonal = ca.cedulaPersonal
        WHERE a.idArea = p_idArea;
    END IF;
END //

-- 20. Generar informe de alojamientos ocupados
CREATE PROCEDURE InformeAlojamientosOcupados(
    IN p_fecha DATE
)
BEGIN
    SELECT a.nombreAlojamiento, p.nombreParque, COUNT(ra.cedulaVisitante) AS Visitantes,
           a.capacidadAlojamiento, 
           CASE 
               WHEN COUNT(ra.cedulaVisitante) >= a.capacidadAlojamiento THEN 'Completo'
               ELSE 'Disponible'
           END AS Estado
    FROM alojamiento a
    JOIN parque p ON a.idParque = p.idParque
    LEFT JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
    WHERE p_fecha BETWEEN ra.fechaEntradaReservaAlojamiento AND ra.fechaSalidaReservaAlojamiento
    GROUP BY a.idAlojamiento, a.nombreAlojamiento, p.nombreParque, a.capacidadAlojamiento;
END //

DELIMITER ;