-- In this document you will find the SQL code to execute events from the tables of the database.

DELIMITER //

-- 1. Notificación semanal de visitantes por parque
CREATE EVENT NotificarVisitantesSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Mostrar mensaje con el conteo de visitantes por parque en la última semana
    SELECT CONCAT('Reporte semanal: Parque ', p.nombreParque, ' tuvo ', 
                  COUNT(rv.idRegistroVisita), ' visitantes en la última semana.')
    FROM parque p
    LEFT JOIN entrada e ON p.idParque = e.idParque
    LEFT JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
    WHERE rv.fechaRegistroVisita >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    GROUP BY p.idParque, p.nombreParque;
END //

-- 2. Actualización de reservas activas de manera temporal
CREATE EVENT MarcarReservasActivasSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Actualizar una columna temporal en reservaAlojamiento para indicar reservas activas
    UPDATE reservaAlojamiento
    SET fechaSalidaReservaAlojamiento = fechaSalidaReservaAlojamiento
    WHERE NOW() BETWEEN fechaEntradaReservaAlojamiento AND fechaSalidaReservaAlojamiento;
END //

-- 3. Aumento mensual de la cantidad de individuos de una especie
CREATE EVENT IncrementarInventarioAnimales
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Aumenta en un 5% el inventario de cada especie como una proyección del crecimiento poblacional
    UPDATE EspecieArea ea
    JOIN especie e ON ea.idEspecie = e.idEspecie
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 1.05
    WHERE e.tipo = 'animal';
END //

-- 4. Actualización de alojamientos cada semana
CREATE EVENT NotificarAlojamientosOcupadosSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal que actualiza el estado de los alojamientos
    SELECT CONCAT('Reporte semanal: Parque ', p.nombreParque, ' tiene ', 
                  COUNT(DISTINCT ra.idAlojamiento), ' alojamientos ocupados.')
    FROM parque p
    LEFT JOIN alojamiento a ON p.idParque = a.idParque
    LEFT JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
    WHERE NOW() BETWEEN ra.fechaEntradaReservaAlojamiento AND ra.fechaSalidaReservaAlojamiento
    GROUP BY p.idParque, p.nombreParque;
END //

-- 5. Reducción trismestral de las especies vegetales
CREATE EVENT ReducirInventarioVegetales
ON SCHEDULE EVERY 3 MONTH
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reduce un 2% el inventario de especies vegetales cada tres meses
    UPDATE EspecieArea ea
    JOIN especie e ON ea.idEspecie = e.idEspecie
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 0.98
    WHERE e.tipo = 'vegetal';
END //

-- 6. Número de visitantes por semana en cada entrada   
CREATE EVENT NotificarVisitantesPorEntradaSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal con el conteo de visitantes por cada entrada
    SELECT CONCAT('Reporte semanal: Entrada ', e.numeroEntrada, ' del parque ', 
                  p.nombreParque, ' tuvo ', COUNT(rv.idRegistroVisita), ' visitantes.')
    FROM entrada e
    JOIN parque p ON e.idParque = p.idParque
    LEFT JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
    WHERE rv.fechaRegistroVisita >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    GROUP BY e.idEntrada, e.numeroEntrada, p.nombreParque;
END //

-- 7. Reducción semestral del inventario de especies minerales
CREATE EVENT ReducirInventarioMinerales
ON SCHEDULE EVERY 6 MONTH
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reduce en un 10% la cantidad de minerales
    UPDATE EspecieArea ea
    JOIN especie e ON ea.idEspecie = e.idEspecie
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 0.90
    WHERE e.tipo = 'mineral';
END //

-- 8. Reporte semanal de vigilantes por área
CREATE EVENT NotificarVigilantesSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal de vigilantes por área
    SELECT CONCAT('Reporte semanal: Área ', a.nombreArea, ' tiene ', 
                  COUNT(va.cedulaPersonal), ' vigilantes asignados.')
    FROM area a
    LEFT JOIN vigilanciaArea va ON a.idArea = va.idArea
    GROUP BY a.idArea, a.nombreArea;
END //

-- 9. Reporte semanal de reservas por categoría
CREATE EVENT NotificarReservasCategoriaSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal de reservas por categoría
    SELECT CONCAT('Reporte semanal: Categoría ', a.categoriaAlojamiento, ' tiene ', 
                  COUNT(ra.idAlojamiento), ' reservas activas.')
    FROM alojamiento a
    LEFT JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
    WHERE NOW() BETWEEN ra.fechaEntradaReservaAlojamiento AND ra.fechaSalidaReservaAlojamiento
    GROUP BY a.categoriaAlojamiento;
END //

-- 10. Incremento anual de sueldos del personal
CREATE EVENT IncrementarSueldosPersonal
ON SCHEDULE EVERY 1 YEAR
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Aumenta el sueldo del personal 3%
    UPDATE personal
    SET sueldoPersonal = sueldoPersonal * 1.03;
END //

-- 11. Reporte semanal de proyectos activos
CREATE EVENT NotificarProyectosActivosSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal de proyectos activos por parque
    SELECT CONCAT('Reporte semanal: Parque ', p.nombreParque, ' tiene ', 
                  COUNT(pi.idProyectoInvestigacion), ' proyectos activos.')
    FROM parque p
    LEFT JOIN area a ON p.idParque = a.idParque
    LEFT JOIN EspecieArea ea ON a.idArea = ea.idArea
    LEFT JOIN EspecieProyecto ep ON ea.idEspecie = ep.idEspecie
    LEFT JOIN proyectoInvestigacion pi ON ep.idProyectoInvestigacion = pi.idProyectoInvestigacion
    WHERE NOW() BETWEEN pi.fechaInicioProyectoInvestigacion AND pi.fechaFinProyectoInvestigacion
    GROUP BY p.idParque, p.nombreParque;
END //

-- 12. Reducción mensual áreas críticas
CREATE EVENT ReducirInventarioAreasCriticas
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reduce 5% el inventario en áreas menores a 2000 hectáreas
    UPDATE EspecieArea ea
    JOIN area a ON ea.idArea = a.idArea
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 0.95
    WHERE a.extensionArea < 2000;
END //

-- 13. Reporte semanal de visitantes por profesión
CREATE EVENT NotificarVisitantesProfesionSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal del conteo de visitantes por profesión
    SELECT CONCAT('Reporte semanal: Profesión ', v.profesionVisitante, ' tuvo ', 
                  COUNT(rv.idRegistroVisita), ' visitantes.')
    FROM visitante v
    LEFT JOIN registroVisita rv ON v.cedulaVisitante = rv.cedulaVisitante
    WHERE rv.fechaRegistroVisita >= DATE_SUB(NOW(), INTERVAL 7 DAY)
    GROUP BY v.profesionVisitante;
END //

-- 14. Incremento trimestral de áreas protegidas
CREATE EVENT IncrementarInventarioAreasProtegidas
ON SCHEDULE EVERY 3 MONTH
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Aumentar en un 3% la cantidad de individuos en áreas mayores a 3000 hectáreas
    UPDATE EspecieArea ea
    JOIN area a ON ea.idArea = a.idArea
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 1.03
    WHERE a.extensionArea > 3000;
END //

-- 15. Reporte semanal de costos operativos
CREATE EVENT NotificarCostosOperativosSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal del costo total del personal por parque
    SELECT CONCAT('Reporte semanal: Parque ', p.nombreParque, ' tiene un costo operativo de $', 
                  SUM(COALESCE(per.sueldoPersonal, 0)), '.')
    FROM parque p
    LEFT JOIN area a ON p.idParque = a.idParque
    LEFT JOIN vigilanciaArea va ON a.idArea = va.idArea
    LEFT JOIN conservacionArea ca ON a.idArea = ca.idArea
    LEFT JOIN personal per ON per.cedulaPersonal = va.cedulaPersonal OR per.cedulaPersonal = ca.cedulaPersonal
    GROUP BY p.idParque, p.nombreParque;
END //

-- 16. Incremento anual en proyectos de conservación
CREATE EVENT IncrementarInventarioProyectosConservacion
ON SCHEDULE EVERY 1 YEAR
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Aumenta 10% el inventario de especies en proyectos activos
    UPDATE EspecieArea ea
    JOIN EspecieProyecto ep ON ea.idEspecie = ep.idEspecie
    JOIN proyectoInvestigacion pi ON ep.idProyectoInvestigacion = pi.idProyectoInvestigacion
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 1.10
    WHERE NOW() BETWEEN pi.fechaInicioProyectoInvestigacion AND pi.fechaFinProyectoInvestigacion;
END //

-- 17. Reporte semanal de vehículos asignados
CREATE EVENT NotificarVehiculosVigilanciaSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte semanal del conteo de vehículos asignados por parque
    SELECT CONCAT('Reporte semanal: Parque ', p.nombreParque, ' tiene ', 
                  COUNT(DISTINCT vv.idVehiculo), ' vehículos asignados.')
    FROM parque p
    LEFT JOIN area a ON p.idParque = a.idParque
    LEFT JOIN vigilanciaArea va ON a.idArea = va.idArea
    LEFT JOIN vehiculoVigilante vv ON va.cedulaPersonal = vv.cedulaPersonal
    GROUP BY p.idParque, p.nombreParque;
END //

-- 18. Reducción mensual de los individuos por turismo
CREATE EVENT ReducirInventarioPresionTuristica
ON SCHEDULE EVERY 1 MONTH
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reduce 5% el inventario en áreas con más de 50 visitantes en el último mes
    UPDATE EspecieArea ea
    JOIN area a ON ea.idArea = a.idArea
    JOIN entrada e ON a.idParque = e.idParque
    JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 0.95
    WHERE rv.fechaRegistroVisita >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
    GROUP BY ea.idEspecie, ea.idArea
    HAVING COUNT(rv.idRegistroVisita) > 50;
END //

-- 19. Notificación semanal de especies por tipo
CREATE EVENT NotificarEspeciesPorTipoSemanal
ON SCHEDULE EVERY 1 WEEK
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Reporte del conteo de especies por tipo en cada área
    SELECT CONCAT('Reporte semanal: Área ', a.nombreArea, ' tiene ', 
                  COUNT(ea.idEspecie), ' especies de tipo ', e.tipo, '.')
    FROM area a
    LEFT JOIN EspecieArea ea ON a.idArea = ea.idArea
    LEFT JOIN especie e ON ea.idEspecie = e.idEspecie
    GROUP BY a.idArea, a.nombreArea, e.tipo;
END //

-- 20. Incremento trimestral del especies por condiciones climáticas
CREATE EVENT IncrementarInventarioCondicionesClimaticas
ON SCHEDULE EVERY 3 MONTH
STARTS '2024-01-01 00:00:00'
DO
BEGIN
    -- Aumenta 2% el inventario de especies vegetales en áreas mayores a 4000 hectáreas
    UPDATE EspecieArea ea
    JOIN especie e ON ea.idEspecie = e.idEspecie
    JOIN area a ON ea.idArea = a.idArea
    SET ea.numeroInventarioEspecieArea = ea.numeroInventarioEspecieArea * 1.02
    WHERE e.tipo = 'vegetal' AND a.extensionArea > 4000;
END //

DELIMITER ;