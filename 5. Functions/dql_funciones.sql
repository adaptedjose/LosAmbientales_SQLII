-- In this document you will find the SQL code to execute data procedures from the tables of the database.

DELIMITER //

-- 1. Superficie total de áreas por parque
CREATE FUNCTION SuperficieTotalPorParque(p_idParque INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE superficie_total DECIMAL(15,2);
    SELECT SUM(extensionArea) INTO superficie_total
    FROM area
    WHERE idParque = p_idParque;
    RETURN IFNULL(superficie_total, 0);
END //

-- 2. Superficie total de parques por departamento
CREATE FUNCTION SuperficieTotalPorDepartamento(p_idDepartamento INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE superficie_total DECIMAL(15,2);
    SELECT SUM(a.extensionArea) INTO superficie_total
    FROM area a
    JOIN parque p ON a.idParque = p.idParque
    JOIN departamentoParque dp ON p.idParque = dp.idParque
    WHERE dp.idDepartamento = p_idDepartamento;
    RETURN IFNULL(superficie_total, 0);
END //

-- 3. Cantidad de especies por área
CREATE FUNCTION CantidadEspeciesPorArea(p_idArea INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_especies INT;
    SELECT COUNT(*) INTO total_especies
    FROM EspecieArea
    WHERE idArea = p_idArea;
    RETURN total_especies;
END //

-- 4. Inventario total de especies por tipo en un área
CREATE FUNCTION InventarioEspeciesPorTipoArea(p_idArea INT, p_tipo ENUM('vegetal', 'animal', 'mineral'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_inventario INT;
    SELECT SUM(ea.numeroInventarioEspecieArea) INTO total_inventario
    FROM EspecieArea ea
    JOIN especie e ON ea.idEspecie = e.idEspecie
    WHERE ea.idArea = p_idArea AND e.tipo = p_tipo;
    RETURN IFNULL(total_inventario, 0);
END //

-- 5. Cantidad de especies por tipo en un parque
CREATE FUNCTION CantidadEspeciesPorTipoParque(p_idParque INT, p_tipo ENUM('vegetal', 'animal', 'mineral'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_especies INT;
    SELECT COUNT(DISTINCT ea.idEspecie) INTO total_especies
    FROM EspecieArea ea
    JOIN area a ON ea.idArea = a.idArea
    JOIN especie e ON ea.idEspecie = e.idEspecie
    WHERE a.idParque = p_idParque AND e.tipo = p_tipo;
    RETURN total_especies;
END //

-- 6. Costo total de proyectos por parque
CREATE FUNCTION CostoProyectosPorParque(p_idParque INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE costo_total DECIMAL(15,2);
    SELECT SUM(pi.presupuestoProyectoInvestigacion) INTO costo_total
    FROM proyectoInvestigacion pi
    JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
    JOIN EspecieArea ea ON ep.idEspecie = ea.idEspecie
    JOIN area a ON ea.idArea = a.idArea
    WHERE a.idParque = p_idParque;
    RETURN IFNULL(costo_total, 0);
END //

-- 7. Costo promedio de proyectos por investigador
CREATE FUNCTION CostoPromedioProyectosInvestigador(p_cedulaPersonal VARCHAR(20))
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE costo_promedio DECIMAL(15,2);
    SELECT AVG(pi.presupuestoProyectoInvestigacion) INTO costo_promedio
    FROM proyectoInvestigacion pi
    JOIN investigadorProyecto ip ON pi.idProyectoInvestigacion = ip.idProyectoInvestigacion
    WHERE ip.cedulaPersonal = p_cedulaPersonal;
    RETURN IFNULL(costo_promedio, 0);
END //

-- 8. Cantidad de visitantes por parque en un año
CREATE FUNCTION VisitantesPorParqueAnio(p_idParque INT, p_anio INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_visitantes INT;
    SELECT COUNT(*) INTO total_visitantes
    FROM registroVisita rv
    JOIN entrada e ON rv.idEntrada = e.idEntrada
    WHERE e.idParque = p_idParque AND YEAR(rv.fechaRegistroVisita) = p_anio;
    RETURN total_visitantes;
END //

-- 9. Capacidad total de alojamientos por parque
CREATE FUNCTION CapacidadAlojamientosParque(p_idParque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE capacidad_total INT;
    SELECT SUM(capacidadAlojamiento) INTO capacidad_total
    FROM alojamiento
    WHERE idParque = p_idParque;
    RETURN IFNULL(capacidad_total, 0);
END //

-- 10. Cantidad de personal por tipo en un área
CREATE FUNCTION PersonalPorTipoArea(p_idArea INT, p_tipoPersonal ENUM('001','002','003','004'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_personal INT;
    SELECT COUNT(DISTINCT p.cedulaPersonal) INTO total_personal
    FROM personal p
    LEFT JOIN vigilanciaArea va ON p.cedulaPersonal = va.cedulaPersonal
    LEFT JOIN conservacionArea ca ON p.cedulaPersonal = ca.cedulaPersonal
    WHERE (va.idArea = p_idArea OR ca.idArea = p_idArea) AND p.tipoPersonal = p_tipoPersonal;
    RETURN total_personal;
END //

-- 11. Costo operativo mensual de personal por parque
CREATE FUNCTION CostoPersonalParqueMensual(p_idParque INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE costo_total DECIMAL(15,2);
    SELECT SUM(p.sueldoPersonal) INTO costo_total
    FROM personal p
    LEFT JOIN vigilanciaArea va ON p.cedulaPersonal = va.cedulaPersonal
    LEFT JOIN conservacionArea ca ON p.cedulaPersonal = ca.cedulaPersonal
    JOIN area a ON va.idArea = a.idArea OR ca.idArea = a.idArea
    WHERE a.idParque = p_idParque;
    RETURN IFNULL(costo_total, 0);
END //

-- 12. Número de vehículos asignados a vigilantes por parque
CREATE FUNCTION VehiculosPorParque(p_idParque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_vehiculos INT;
    SELECT COUNT(DISTINCT vv.idVehiculo) INTO total_vehiculos
    FROM vehiculoVigilante vv
    JOIN vigilanciaArea va ON vv.cedulaPersonal = va.cedulaPersonal
    JOIN area a ON va.idArea = a.idArea
    WHERE a.idParque = p_idParque;
    RETURN total_vehiculos;
END //

-- 13. Presupuesto promedio de proyectos por especie
CREATE FUNCTION PresupuestoPromedioPorEspecie(p_idEspecie INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE presupuesto_promedio DECIMAL(15,2);
    SELECT AVG(pi.presupuestoProyectoInvestigacion) INTO presupuesto_promedio
    FROM proyectoInvestigacion pi
    JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
    WHERE ep.idEspecie = p_idEspecie;
    RETURN IFNULL(presupuesto_promedio, 0);
END //

-- 14. Duración promedio de proyectos por parque
CREATE FUNCTION DuracionPromedioProyectosParque(p_idParque INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE duracion_promedio DECIMAL(10,2);
    SELECT AVG(DATEDIFF(pi.fechaFinProyectoInvestigacion, pi.fechaInicioProyectoInvestigacion)) INTO duracion_promedio
    FROM proyectoInvestigacion pi
    JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
    JOIN EspecieArea ea ON ep.idEspecie = ea.idEspecie
    JOIN area a ON ea.idArea = a.idArea
    WHERE a.idParque = p_idParque;
    RETURN IFNULL(duracion_promedio, 0);
END //

-- 15. Cantidad de alojamientos ocupados por parque en una fecha
CREATE FUNCTION AlojamientosOcupadosParque(p_idParque INT, p_fecha DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_ocupados INT;
    SELECT COUNT(DISTINCT ra.idAlojamiento) INTO total_ocupados
    FROM reservaAlojamiento ra
    JOIN alojamiento al ON ra.idAlojamiento = al.idAlojamiento
    WHERE al.idParque = p_idParque
    AND p_fecha BETWEEN ra.fechaEntradaReservaAlojamiento AND ra.fechaSalidaReservaAlojamiento;
    RETURN total_ocupados;
END //

-- 16. Total de especies en proyectos por investigador
CREATE FUNCTION EspeciesPorInvestigador(p_cedulaPersonal VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_especies INT;
    SELECT COUNT(DISTINCT ep.idEspecie) INTO total_especies
    FROM EspecieProyecto ep
    JOIN investigadorProyecto ip ON ep.idProyectoInvestigacion = ip.idProyectoInvestigacion
    WHERE ip.cedulaPersonal = p_cedulaPersonal;
    RETURN total_especies;
END //

-- 17. Costo total de alojamientos por categoría en un parque
CREATE FUNCTION CostoAlojamientosPorCategoria(p_idParque INT, p_categoria ENUM('Económico','Medio','Lujo'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE costo_total INT;
    SELECT SUM(capacidadAlojamiento) INTO costo_total
    FROM alojamiento
    WHERE idParque = p_idParque AND categoriaAlojamiento = p_categoria;
    RETURN IFNULL(costo_total, 0);
END //

-- 18. Inventario total de especies por parque
CREATE FUNCTION InventarioTotalEspeciesParque(p_idParque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_inventario INT;
    SELECT SUM(ea.numeroInventarioEspecieArea) INTO total_inventario
    FROM EspecieArea ea
    JOIN area a ON ea.idArea = a.idArea
    WHERE a.idParque = p_idParque;
    RETURN IFNULL(total_inventario, 0);
END //

-- 19. Cantidad de entradas por parque
CREATE FUNCTION CantidadEntradasParque(p_idParque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_entradas INT;
    SELECT COUNT(*) INTO total_entradas
    FROM entrada
    WHERE idParque = p_idParque;
    RETURN total_entradas;
END //

-- 20. Costo operativo anual de proyectos por departamento
CREATE FUNCTION CostoProyectosDepartamentoAnual(p_idDepartamento INT, p_anio INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    DECLARE costo_total DECIMAL(15,2);
    SELECT SUM(pi.presupuestoProyectoInvestigacion) INTO costo_total
    FROM proyectoInvestigacion pi
    JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
    JOIN EspecieArea ea ON ep.idEspecie = ea.idEspecie
    JOIN area a ON ea.idArea = a.idArea
    JOIN departamentoParque dp ON a.idParque = dp.idParque
    WHERE dp.idDepartamento = p_idDepartamento AND YEAR(pi.fechaInicioProyectoInvestigacion) = p_anio;
    RETURN IFNULL(costo_total, 0);
END //

DELIMITER ;