-- In this document you will find the SQL code to consult data from the tables of the database.

-- 1. Cantidad de parques por departamento
SELECT d.nombreDepartamento, COUNT(dp.idParque) AS cantidadParques
FROM departamento d
LEFT JOIN departamentoParque dp ON d.idDepartamento = dp.idDepartamento
GROUP BY d.nombreDepartamento
ORDER BY cantidadParques DESC;

-- 2. Parques declarados antes del año 2000 por departamento
SELECT d.nombreDepartamento, COUNT(p.idParque) AS parquesAntiguos
FROM departamento d
JOIN departamentoParque dp ON d.idDepartamento = dp.idDepartamento
JOIN parque p ON dp.idParque = p.idParque
WHERE p.fechaDeclaracionParque < '2000-01-01'
GROUP BY d.nombreDepartamento;

-- 3. Superficie total de áreas por parque
SELECT p.nombreParque, SUM(a.extensionArea) AS superficieTotal
FROM parque p
LEFT JOIN area a ON p.idParque = a.idParque
GROUP BY p.nombreParque
ORDER BY superficieTotal DESC;

-- 4. Departamentos con más de un parque
SELECT d.nombreDepartamento, COUNT(dp.idParque) AS cantidadParques
FROM departamento d
JOIN departamentoParque dp ON d.idDepartamento = dp.idDepartamento
GROUP BY d.nombreDepartamento
HAVING COUNT(dp.idParque) > 1;

-- 5. Parques sin áreas registradas
SELECT p.nombreParque
FROM parque p
LEFT JOIN area a ON p.idParque = a.idParque
WHERE a.idArea IS NULL;

-- 6. Superficie promedio de áreas por departamento
SELECT d.nombreDepartamento, AVG(a.extensionArea) AS superficiePromedio
FROM departamento d
JOIN departamentoParque dp ON d.idDepartamento = dp.idDepartamento
JOIN parque p ON dp.idParque = p.idParque
JOIN area a ON p.idParque = a.idParque
GROUP BY d.nombreDepartamento;

-- 7. Parques declarados en el siglo XXI
SELECT nombreParque, fechaDeclaracionParque
FROM parque
WHERE fechaDeclaracionParque >= '2000-01-01'
ORDER BY fechaDeclaracionParque;

-- 8. Departamento con la mayor superficie total
SELECT d.nombreDepartamento, SUM(a.extensionArea) AS superficieTotal
FROM departamento d
JOIN departamentoParque dp ON d.idDepartamento = dp.idDepartamento
JOIN parque p ON dp.idParque = p.idParque
JOIN area a ON p.idParque = a.idParque
GROUP BY d.nombreDepartamento
ORDER BY superficieTotal DESC
LIMIT 1;

-- 9. Parques por entidad responsable
SELECT er.nombreEntidadResponsable, COUNT(dp.idParque) AS cantidadParques
FROM entidadResponsable er
JOIN departamento d ON er.idEntidadResponsable = d.idEntidadResponsable
JOIN departamentoParque dp ON d.idDepartamento = dp.idDepartamento
GROUP BY er.nombreEntidadResponsable;

-- 10. Años con más declaraciones de parques
SELECT YEAR(fechaDeclaracionParque) AS anio, COUNT(*) AS cantidad
FROM parque
GROUP BY YEAR(fechaDeclaracionParque)
ORDER BY cantidad DESC
LIMIT 5;

-- 11. Cantidad de especies por tipo
SELECT tipo, COUNT(*) AS totalEspecies
FROM especie
GROUP BY tipo;

-- 12. Especies por área
SELECT a.nombreArea, COUNT(ea.idEspecie) AS cantidadEspecies
FROM area a
LEFT JOIN EspecieArea ea ON a.idArea = ea.idArea
GROUP BY a.nombreArea;

-- 13. Áreas con más de 5 especies animales
SELECT a.nombreArea, COUNT(ea.idEspecie) AS especiesAnimales
FROM area a
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
WHERE e.tipo = 'animal'
GROUP BY a.nombreArea
HAVING COUNT(ea.idEspecie) > 5;

-- 14. Especies vegetales por parque
SELECT p.nombreParque, COUNT(e.idEspecie) AS especiesVegetales
FROM parque p
JOIN area a ON p.idParque = a.idParque
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
WHERE e.tipo = 'vegetal'
GROUP BY p.nombreParque;

-- 15. Áreas sin especies registradas
SELECT a.nombreArea
FROM area a
LEFT JOIN EspecieArea ea ON a.idArea = ea.idArea
WHERE ea.idEspecie IS NULL;

-- 16. Especies únicas por tipo
SELECT tipo, COUNT(DISTINCT denominacionCientificaEspecie) AS especiesUnicas
FROM especie
GROUP BY tipo;

-- 17. Parques con especies minerales
SELECT DISTINCT p.nombreParque
FROM parque p
JOIN area a ON p.idParque = a.idParque
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
WHERE e.tipo = 'mineral';

-- 18. Promedio de inventario de especies por área
SELECT a.nombreArea, AVG(ea.numeroInventarioEspecieArea) AS promedioInventario
FROM area a
JOIN EspecieArea ea ON a.idArea = ea.idArea
GROUP BY a.nombreArea;

-- 19. Especies con nombre vulgar nulo
SELECT denominacionCientificaEspecie, tipo
FROM especie
WHERE denominacionVulgarEspecie IS NULL;

-- 20. Área con mayor número de especies
SELECT a.nombreArea, COUNT(ea.idEspecie) AS totalEspecies
FROM area a
JOIN EspecieArea ea ON a.idArea = ea.idArea
GROUP BY a.nombreArea
ORDER BY totalEspecies DESC
LIMIT 1;

-- 21. Especies en más de un área (subconsulta)
SELECT e.denominacionCientificaEspecie, COUNT(ea.idArea) AS areas
FROM especie e
JOIN EspecieArea ea ON e.idEspecie = ea.idEspecie
GROUP BY e.idEspecie, e.denominacionCientificaEspecie
HAVING COUNT(ea.idArea) > 1;

-- 22. Parques con más especies animales que vegetales
SELECT p.nombreParque,
       SUM(CASE WHEN e.tipo = 'animal' THEN 1 ELSE 0 END) AS animales,
       SUM(CASE WHEN e.tipo = 'vegetal' THEN 1 ELSE 0 END) AS vegetales
FROM parque p
JOIN area a ON p.idParque = a.idParque
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
GROUP BY p.nombreParque
HAVING animales > vegetales;

-- 23. Especies por proyecto de investigación
SELECT pi.nombreProyectoInvestigacion, COUNT(ep.idEspecie) AS especies
FROM proyectoInvestigacion pi
LEFT JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
GROUP BY pi.nombreProyectoInvestigacion;

-- 24. Áreas con especies en peligro (suponiendo nombres científicos específicos)
SELECT a.nombreArea, e.denominacionCientificaEspecie
FROM area a
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
WHERE e.denominacionCientificaEspecie IN ('Panthera onca', 'Vultur gryphus', 'Tremarctos ornatus');

-- 25. Distribución de especies por tipo en cada parque
SELECT p.nombreParque, e.tipo, COUNT(e.idEspecie) AS cantidad
FROM parque p
JOIN area a ON p.idParque = a.idParque
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
GROUP BY p.nombreParque, e.tipo;

-- 26. Especies más inventariadas por área
SELECT a.nombreArea, e.denominacionCientificaEspecie, ea.numeroInventarioEspecieArea
FROM area a
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
WHERE ea.numeroInventarioEspecieArea = (
    SELECT MAX(numeroInventarioEspecieArea)
    FROM EspecieArea ea2
    WHERE ea2.idArea = a.idArea
);

-- 27. Parques sin especies animales
SELECT p.nombreParque
FROM parque p
WHERE NOT EXISTS (
    SELECT 1
    FROM area a
    JOIN EspecieArea ea ON a.idArea = ea.idArea
    JOIN especie e ON ea.idEspecie = e.idEspecie
    WHERE a.idParque = p.idParque AND e.tipo = 'animal'
);

-- 28. Áreas con diversidad máxima (todos los tipos de especies)
SELECT a.nombreArea
FROM area a
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
GROUP BY a.nombreArea
HAVING COUNT(DISTINCT e.tipo) = 3;

-- 29. Especies compartidas entre áreas de un mismo parque
SELECT p.nombreParque, e.denominacionCientificaEspecie, COUNT(ea.idArea) AS areas
FROM parque p
JOIN area a ON p.idParque = a.idParque
JOIN EspecieArea ea ON a.idArea = ea.idArea
JOIN especie e ON ea.idEspecie = e.idEspecie
GROUP BY p.nombreParque, e.idEspecie, e.denominacionCientificaEspecie
HAVING COUNT(ea.idArea) > 1;

-- 30. Áreas con inventario promedio superior al general
SELECT a.nombreArea, AVG(ea.numeroInventarioEspecieArea) AS promedioArea
FROM area a
JOIN EspecieArea ea ON a.idArea = ea.idArea
GROUP BY a.nombreArea
HAVING AVG(ea.numeroInventarioEspecieArea) > (
    SELECT AVG(numeroInventarioEspecieArea)
    FROM EspecieArea
);

-- 31. Personal por tipo
SELECT tipoPersonal, COUNT(*) AS cantidad
FROM personal
GROUP BY tipoPersonal;

-- 32. Sueldo promedio por tipo de personal
SELECT tipoPersonal, AVG(sueldoPersonal) AS sueldoPromedio
FROM personal
GROUP BY tipoPersonal;

-- 33. Personal con más de un teléfono
SELECT p.nombrePersonal, COUNT(tp.telefonoPersonal) AS telefonos
FROM personal p
JOIN telefonoPersonal tp ON p.cedulaPersonal = tp.cedulaPersonal
GROUP BY p.cedulaPersonal, p.nombrePersonal
HAVING COUNT(tp.telefonoPersonal) > 1;

-- 34. Vigilantes por área
SELECT a.nombreArea, COUNT(va.cedulaPersonal) AS vigilantes
FROM area a
LEFT JOIN vigilanciaArea va ON a.idArea = va.idArea
GROUP BY a.nombreArea;

-- 35. Personal de conservación por especialidad
SELECT especialidadConservacionArea, COUNT(*) AS cantidad
FROM conservacionArea
GROUP BY especialidadConservacionArea;

-- 36. Sueldo total del personal de gestión
SELECT SUM(p.sueldoPersonal) AS sueldoTotalGestion
FROM personal p
JOIN personalGestion pg ON p.cedulaPersonal = pg.cedulaPersonalGestion;

-- 37. Personal con sueldo superior al promedio
SELECT nombrePersonal, sueldoPersonal
FROM personal
WHERE sueldoPersonal > (SELECT AVG(sueldoPersonal) FROM personal)
ORDER BY sueldoPersonal DESC;

-- 38. Vigilantes con vehículos asignados
SELECT p.nombrePersonal, COUNT(vv.idVehiculo) AS vehiculos
FROM personal p
JOIN vehiculoVigilante vv ON p.cedulaPersonal = vv.cedulaPersonal
WHERE p.tipoPersonal = '002'
GROUP BY p.cedulaPersonal, p.nombrePersonal;

-- 39. Áreas sin personal de conservación
SELECT a.nombreArea
FROM area a
LEFT JOIN conservacionArea ca ON a.idArea = ca.idArea
WHERE ca.cedulaPersonal IS NULL;

-- 40. Personal en más de un proyecto de investigación
SELECT p.nombrePersonal, COUNT(ip.idProyectoInvestigacion) AS proyectos
FROM personal p
JOIN investigadorProyecto ip ON p.cedulaPersonal = ip.cedulaPersonal
GROUP BY p.cedulaPersonal, p.nombrePersonal
HAVING COUNT(ip.idProyectoInvestigacion) > 1;

-- 41. Sueldo máximo por tipo de personal
SELECT tipoPersonal, MAX(sueldoPersonal) AS sueldoMaximo
FROM personal
GROUP BY tipoPersonal;

-- 42. Vigilantes con asignaciones recientes (2023)
SELECT p.nombrePersonal, vv.fechaAsignacionVehiculoVisitante
FROM personal p
JOIN vehiculoVigilante vv ON p.cedulaPersonal = vv.cedulaPersonal
WHERE YEAR(vv.fechaAsignacionVehiculoVisitante) = 2023;

-- 43. Personal sin teléfono registrado
SELECT nombrePersonal
FROM personal p
LEFT JOIN telefonoPersonal tp ON p.cedulaPersonal = tp.cedulaPersonal
WHERE tp.telefonoPersonal IS NULL;

-- 44. Áreas con más personal de vigilancia
SELECT a.nombreArea, COUNT(va.cedulaPersonal) AS vigilantes
FROM area a
JOIN vigilanciaArea va ON a.idArea = va.idArea
GROUP BY a.nombreArea
ORDER BY vigilantes DESC
LIMIT 3;

-- 45. Sueldo promedio de investigadores por proyecto
SELECT pi.nombreProyectoInvestigacion, AVG(p.sueldoPersonal) AS sueldoPromedio
FROM proyectoInvestigacion pi
JOIN investigadorProyecto ip ON pi.idProyectoInvestigacion = ip.idProyectoInvestigacion
JOIN personal p ON ip.cedulaPersonal = p.cedulaPersonal
GROUP BY pi.nombreProyectoInvestigacion;

-- 46. Personal con múltiples roles (subconsulta)
SELECT DISTINCT p.nombrePersonal
FROM personal p
WHERE p.cedulaPersonal IN (
    SELECT cedulaPersonal FROM vigilanciaArea
) AND p.cedulaPersonal IN (
    SELECT cedulaPersonal FROM conservacionArea
);

-- 47. Vehículos más usados por vigilantes
SELECT v.tipoVehiculo, v.marcaVehiculo, COUNT(vv.cedulaPersonal) AS asignaciones
FROM vehiculo v
JOIN vehiculoVigilante vv ON v.idVehiculo = vv.idVehiculo
GROUP BY v.idVehiculo, v.tipoVehiculo, v.marcaVehiculo
ORDER BY asignaciones DESC;

-- 48. Personal con sueldo por debajo del mínimo de su tipo
SELECT p.nombrePersonal, p.sueldoPersonal, p.tipoPersonal
FROM personal p
WHERE p.sueldoPersonal < (
    SELECT MIN(sueldoPersonal)
    FROM personal p2
    WHERE p2.tipoPersonal = p.tipoPersonal
);

-- 49. Distribución de personal por parque
SELECT p.nombreParque, COUNT(DISTINCT per.cedulaPersonal) AS totalPersonal
FROM parque p
JOIN area a ON p.idParque = a.idParque
LEFT JOIN vigilanciaArea va ON a.idArea = va.idArea
LEFT JOIN conservacionArea ca ON a.idArea = ca.idArea
LEFT JOIN personal per ON per.cedulaPersonal IN (va.cedulaPersonal, ca.cedulaPersonal)
GROUP BY p.nombreParque;

-- 50. Personal con mayor antigüedad en vehículos
SELECT p.nombrePersonal, MIN(vv.fechaAsignacionVehiculoVisitante) AS primeraAsignacion
FROM personal p
JOIN vehiculoVigilante vv ON p.cedulaPersonal = vv.cedulaPersonal
GROUP BY p.cedulaPersonal, p.nombrePersonal
ORDER BY primeraAsignacion ASC
LIMIT 5;

-- 51. Costo total de proyectos por año de inicio
SELECT YEAR(fechaInicioProyectoInvestigacion) AS anio, SUM(presupuestoProyectoInvestigacion) AS costoTotal
FROM proyectoInvestigacion
GROUP BY YEAR(fechaInicioProyectoInvestigacion);

-- 52. Proyectos con mayor presupuesto
SELECT nombreProyectoInvestigacion, presupuestoProyectoInvestigacion
FROM proyectoInvestigacion
ORDER BY presupuestoProyectoInvestigacion DESC
LIMIT 5;

-- 53. Cantidad de especies por proyecto
SELECT pi.nombreProyectoInvestigacion, COUNT(ep.idEspecie) AS especies
FROM proyectoInvestigacion pi
LEFT JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
GROUP BY pi.nombreProyectoInvestigacion;

-- 54. Proyectos sin especies asociadas
SELECT pi.nombreProyectoInvestigacion
FROM proyectoInvestigacion pi
LEFT JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
WHERE ep.idEspecie IS NULL;

-- 55. Investigadores por proyecto
SELECT pi.nombreProyectoInvestigacion, COUNT(ip.cedulaPersonal) AS investigadores
FROM proyectoInvestigacion pi
LEFT JOIN investigadorProyecto ip ON pi.idProyectoInvestigacion = ip.idProyectoInvestigacion
GROUP BY pi.nombreProyectoInvestigacion;

-- 56. Costo promedio por proyecto
SELECT AVG(presupuestoProyectoInvestigacion) AS costoPromedio
FROM proyectoInvestigacion;

-- 57. Proyectos activos en 2024
SELECT nombreProyectoInvestigacion
FROM proyectoInvestigacion
WHERE fechaInicioProyectoInvestigacion <= '2024-12-31'
AND fechaFinProyectoInvestigacion >= '2024-01-01';

-- 58. Proyectos con más de 3 investigadores
SELECT pi.nombreProyectoInvestigacion, COUNT(ip.cedulaPersonal) AS investigadores
FROM proyectoInvestigacion pi
JOIN investigadorProyecto ip ON pi.idProyectoInvestigacion = ip.idProyectoInvestigacion
GROUP BY pi.nombreProyectoInvestigacion
HAVING COUNT(ip.cedulaPersonal) > 3;

-- 59. Especies más estudiadas en proyectos
SELECT e.denominacionCientificaEspecie, COUNT(ep.idProyectoInvestigacion) AS proyectos
FROM especie e
JOIN EspecieProyecto ep ON e.idEspecie = ep.idEspecie
GROUP BY e.idEspecie, e.denominacionCientificaEspecie
ORDER BY proyectos DESC
LIMIT 5;

-- 60. Costo total por especie estudiada
SELECT e.denominacionCientificaEspecie, SUM(pi.presupuestoProyectoInvestigacion) AS costoTotal
FROM especie e
JOIN EspecieProyecto ep ON e.idEspecie = ep.idEspecie
JOIN proyectoInvestigacion pi ON ep.idProyectoInvestigacion = pi.idProyectoInvestigacion
GROUP BY e.idEspecie, e.denominacionCientificaEspecie;

-- 61. Proyectos con duración superior a 5 años
SELECT nombreProyectoInvestigacion, DATEDIFF(fechaFinProyectoInvestigacion, fechaInicioProyectoInvestigacion) / 365 AS duracionAnios
FROM proyectoInvestigacion
WHERE DATEDIFF(fechaFinProyectoInvestigacion, fechaInicioProyectoInvestigacion) / 365 > 5;

-- 62. Presupuesto promedio por investigador
SELECT pi.nombreProyectoInvestigacion, pi.presupuestoProyectoInvestigacion / COUNT(ip.cedulaPersonal) AS presupuestoPorInvestigador
FROM proyectoInvestigacion pi
JOIN investigadorProyecto ip ON pi.idProyectoInvestigacion = ip.idProyectoInvestigacion
GROUP BY pi.idProyectoInvestigacion, pi.nombreProyectoInvestigacion;

-- 63. Proyectos con especies animales exclusivamente
SELECT pi.nombreProyectoInvestigacion
FROM proyectoInvestigacion pi
JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
JOIN especie e ON ep.idEspecie = e.idEspecie
GROUP BY pi.nombreProyectoInvestigacion
HAVING COUNT(CASE WHEN e.tipo != 'animal' THEN 1 END) = 0;

-- 64. Investigadores con mayor carga de proyectos
SELECT p.nombrePersonal, COUNT(ip.idProyectoInvestigacion) AS proyectos
FROM personal p
JOIN investigadorProyecto ip ON p.cedulaPersonal = ip.cedulaPersonal
GROUP BY p.cedulaPersonal, p.nombrePersonal
ORDER BY proyectos DESC
LIMIT 3;

-- 65. Proyectos con presupuesto superior al promedio
SELECT nombreProyectoInvestigacion, presupuestoProyectoInvestigacion
FROM proyectoInvestigacion
WHERE presupuestoProyectoInvestigacion > (
    SELECT AVG(presupuestoProyectoInvestigacion)
    FROM proyectoInvestigacion
);

-- 66. Proyectos finalizados antes de lo previsto (suponiendo fecha actual 2024-10-01)
SELECT nombreProyectoInvestigacion, fechaFinProyectoInvestigacion
FROM proyectoInvestigacion
WHERE fechaFinProyectoInvestigacion < '2024-10-01'
AND fechaFinProyectoInvestigacion < fechaFinProyectoInvestigacion;

-- 67. Costo por especie en proyectos activos
SELECT e.denominacionCientificaEspecie, SUM(pi.presupuestoProyectoInvestigacion) / COUNT(ep.idProyectoInvestigacion) AS costoPorProyecto
FROM especie e
JOIN EspecieProyecto ep ON e.idEspecie = ep.idEspecie
JOIN proyectoInvestigacion pi ON ep.idProyectoInvestigacion = pi.idProyectoInvestigacion
WHERE pi.fechaFinProyectoInvestigacion > '2024-10-01'
GROUP BY e.idEspecie, e.denominacionCientificaEspecie;

-- 68. Proyectos con equipos de más de 5 investigadores
SELECT pi.nombreProyectoInvestigacion, COUNT(ip.cedulaPersonal) AS equipo
FROM proyectoInvestigacion pi
JOIN investigadorProyecto ip ON pi.idProyectoInvestigacion = ip.idProyectoInvestigacion
GROUP BY pi.nombreProyectoInvestigacion
HAVING COUNT(ip.cedulaPersonal) > 5;

-- 69. Distribución de costos por tipo de especie
SELECT e.tipo, SUM(pi.presupuestoProyectoInvestigacion) AS costoTotal
FROM especie e
JOIN EspecieProyecto ep ON e.idEspecie = ep.idEspecie
JOIN proyectoInvestigacion pi ON ep.idProyectoInvestigacion = pi.idProyectoInvestigacion
GROUP BY e.tipo;

-- 70. Proyectos con mayor diversidad de especies
SELECT pi.nombreProyectoInvestigacion, COUNT(DISTINCT e.tipo) AS tiposEspecies
FROM proyectoInvestigacion pi
JOIN EspecieProyecto ep ON pi.idProyectoInvestigacion = ep.idProyectoInvestigacion
JOIN especie e ON ep.idEspecie = e.idEspecie
GROUP BY pi.nombreProyectoInvestigacion
ORDER BY tiposEspecies DESC
LIMIT 5;

-- 71. Cantidad de visitantes por parque
SELECT p.nombreParque, COUNT(rv.cedulaVisitante) AS visitantes
FROM parque p
JOIN entrada e ON p.idParque = e.idParque
JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
GROUP BY p.nombreParque;

-- 72. Visitantes por profesión
SELECT profesionVisitante, COUNT(*) AS cantidad
FROM visitante
GROUP BY profesionVisitante
ORDER BY cantidad DESC;

-- 73. Ocupación total por alojamiento
SELECT a.nombreAlojamiento, COUNT(ra.cedulaVisitante) AS reservas
FROM alojamiento a
LEFT JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
GROUP BY a.nombreAlojamiento;

-- 74. Alojamientos con mayor capacidad
SELECT nombreAlojamiento, capacidadAlojamiento
FROM alojamiento
ORDER BY capacidadAlojamiento DESC
LIMIT 5;

-- 75. Visitantes con más de una visita
SELECT v.nombreVisitante, COUNT(rv.idRegistroVisita) AS visitas
FROM visitante v
JOIN registroVisita rv ON v.cedulaVisitante = rv.cedulaVisitante
GROUP BY v.cedulaVisitante, v.nombreVisitante
HAVING COUNT(rv.idRegistroVisita) > 1;

-- 76. Alojamientos sin reservas
SELECT a.nombreAlojamiento
FROM alojamiento a
LEFT JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
WHERE ra.cedulaVisitante IS NULL;

-- 77. Promedio de días de estadía por alojamiento
SELECT a.nombreAlojamiento, AVG(DATEDIFF(ra.fechaSalidaReservaAlojamiento, ra.fechaEntradaReservaAlojamiento)) AS diasPromedio
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
GROUP BY a.nombreAlojamiento;

-- 78. Visitantes por mes en 2024
SELECT MONTH(rv.fechaRegistroVisita) AS mes, COUNT(*) AS visitantes
FROM registroVisita rv
WHERE YEAR(rv.fechaRegistroVisita) = 2024
GROUP BY MONTH(rv.fechaRegistroVisita);

-- 79. Alojamientos de lujo ocupados
SELECT a.nombreAlojamiento, COUNT(ra.cedulaVisitante) AS reservas
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
WHERE a.categoriaAlojamiento = 'Lujo'
GROUP BY a.nombreAlojamiento;

-- 80. Personal de gestión con más registros de visitas
SELECT p.nombrePersonal, COUNT(rv.idRegistroVisita) AS registros
FROM personal p
JOIN registroVisita rv ON p.cedulaPersonal = rv.cedulaPersonalGestion
GROUP BY p.cedulaPersonal, p.nombrePersonal
ORDER BY registros DESC
LIMIT 3;

-- 81. Visitantes sin reservas de alojamiento
SELECT v.nombreVisitante
FROM visitante v
LEFT JOIN reservaAlojamiento ra ON v.cedulaVisitante = ra.cedulaVisitante
WHERE ra.idAlojamiento IS NULL;

-- 82. Alojamientos más reservados por categoría
SELECT a.categoriaAlojamiento, a.nombreAlojamiento, COUNT(ra.cedulaVisitante) AS reservas
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
GROUP BY a.categoriaAlojamiento, a.nombreAlojamiento
ORDER BY reservas DESC
LIMIT 3;

-- 83. Parques con mayor afluencia de visitantes
SELECT p.nombreParque, COUNT(rv.cedulaVisitante) AS totalVisitantes
FROM parque p
JOIN entrada e ON p.idParque = e.idParque
JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
GROUP BY p.nombreParque
ORDER BY totalVisitantes DESC
LIMIT 5;

-- 84. Reservas activas en octubre 2024
SELECT a.nombreAlojamiento, COUNT(ra.cedulaVisitante) AS reservasActivas
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
WHERE '2024-10-01' BETWEEN ra.fechaEntradaReservaAlojamiento AND ra.fechaSalidaReservaAlojamiento
GROUP BY a.nombreAlojamiento;

-- 85. Visitantes frecuentes por parque
SELECT p.nombreParque, v.nombreVisitante, COUNT(rv.idRegistroVisita) AS visitas
FROM parque p
JOIN entrada e ON p.idParque = e.idParque
JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
JOIN visitante v ON rv.cedulaVisitante = v.cedulaVisitante
GROUP BY p.nombreParque, v.cedulaVisitante, v.nombreVisitante
HAVING COUNT(rv.idRegistroVisita) > 2;

-- 86. Alojamientos con ocupación completa (subconsulta)
SELECT a.nombreAlojamiento
FROM alojamiento a
WHERE a.capacidadAlojamiento = (
    SELECT COUNT(ra.cedulaVisitante)
    FROM reservaAlojamiento ra
    WHERE ra.idAlojamiento = a.idAlojamiento
    AND '2024-10-01' BETWEEN ra.fechaEntradaReservaAlojamiento AND ra.fechaSalidaReservaAlojamiento
);

-- 87. Visitantes por hora pico (8:00-12:00)
SELECT p.nombreParque, COUNT(rv.cedulaVisitante) AS visitantesManana
FROM parque p
JOIN entrada e ON p.idParque = e.idParque
JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
WHERE HOUR(rv.fechaRegistroVisita) BETWEEN 8 AND 12
GROUP BY p.nombreParque;

-- 88. Alojamientos económicos más populares
SELECT a.nombreAlojamiento, COUNT(ra.cedulaVisitante) AS reservas
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
WHERE a.categoriaAlojamiento = 'Económico'
GROUP BY a.nombreAlojamiento
ORDER BY reservas DESC
LIMIT 3;

-- 89. Visitantes sin dirección registrada
SELECT nombreVisitante
FROM visitante
WHERE direccionVisitante IS NULL;

-- 90. Distribución de reservas por categoría de alojamiento
SELECT a.categoriaAlojamiento, COUNT(ra.cedulaVisitante) AS totalReservas
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
GROUP BY a.categoriaAlojamiento;

-- 91. Parques con menor afluencia
SELECT p.nombreParque, COUNT(rv.cedulaVisitante) AS visitantes
FROM parque p
LEFT JOIN entrada e ON p.idParque = e.idParque
LEFT JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
GROUP BY p.nombreParque
ORDER BY visitantes ASC
LIMIT 5;

-- 92. Visitantes con estadías largas (>7 días)
SELECT v.nombreVisitante, DATEDIFF(ra.fechaSalidaReservaAlojamiento, ra.fechaEntradaReservaAlojamiento) AS dias
FROM visitante v
JOIN reservaAlojamiento ra ON v.cedulaVisitante = ra.cedulaVisitante
WHERE DATEDIFF(ra.fechaSalidaReservaAlojamiento, ra.fechaEntradaReservaAlojamiento) > 7;

-- 93. Alojamientos con mayor rotación
SELECT a.nombreAlojamiento, COUNT(ra.cedulaVisitante) / DATEDIFF(MAX(ra.fechaSalidaReservaAlojamiento), MIN(ra.fechaEntradaReservaAlojamiento)) AS rotacionDiaria
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
GROUP BY a.nombreAlojamiento
ORDER BY rotacionDiaria DESC;

-- 94. Visitantes por entrada específica
SELECT e.numeroEntrada, COUNT(rv.cedulaVisitante) AS visitantes
FROM entrada e
JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
GROUP BY e.numeroEntrada;

-- 95. Alojamientos con reservas en 2025
SELECT a.nombreAlojamiento, COUNT(ra.cedulaVisitante) AS reservas2025
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
WHERE YEAR(ra.fechaEntradaReservaAlojamiento) = 2025
GROUP BY a.nombreAlojamiento;

-- 96. Visitantes atendidos por personal de gestión específico
SELECT p.nombrePersonal, COUNT(rv.cedulaVisitante) AS visitantesAtendidos
FROM personal p
JOIN registroVisita rv ON p.cedulaPersonal = rv.cedulaPersonalGestion
GROUP BY p.cedulaPersonal, p.nombrePersonal;

-- 97. Alojamientos con ocupación por encima del promedio
SELECT a.nombreAlojamiento, COUNT(ra.cedulaVisitante) AS reservas
FROM alojamiento a
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
GROUP BY a.nombreAlojamiento
HAVING COUNT(ra.cedulaVisitante) > (
    SELECT AVG(reservas)
    FROM (
        SELECT idAlojamiento, COUNT(cedulaVisitante) AS reservas
        FROM reservaAlojamiento
        GROUP BY idAlojamiento
    ) AS sub
);

-- 98. Parques con visitantes recurrentes
SELECT p.nombreParque, COUNT(DISTINCT rv.cedulaVisitante) AS visitantesUnicos
FROM parque p
JOIN entrada e ON p.idParque = e.idParque
JOIN registroVisita rv ON e.idEntrada = rv.idEntrada
GROUP BY p.nombreParque
HAVING COUNT(rv.cedulaVisitante) > COUNT(DISTINCT rv.cedulaVisitante);

-- 99. Reservas por duración promedio por parque
SELECT p.nombreParque, AVG(DATEDIFF(ra.fechaSalidaReservaAlojamiento, ra.fechaEntradaReservaAlojamiento)) AS duracionPromedio
FROM parque p
JOIN alojamiento a ON p.idParque = a.idParque
JOIN reservaAlojamiento ra ON a.idAlojamiento = ra.idAlojamiento
GROUP BY p.nombreParque;

-- 100. Visitantes con reservas y visitas simultáneas
SELECT v.nombreVisitante
FROM visitante v
JOIN reservaAlojamiento ra ON v.cedulaVisitante = ra.cedulaVisitante
JOIN registroVisita rv ON v.cedulaVisitante = rv.cedulaVisitante
WHERE rv.fechaRegistroVisita BETWEEN ra.fechaEntradaReservaAlojamiento AND ra.fechaSalidaReservaAlojamiento;