-- In this document you will find the SQL code to control users from the tables of the database and control its permissions.

-- Crear usuarios y contraseñas
CREATE USER 'administrador'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'gestor_parques'@'localhost' IDENTIFIED BY 'parques456';
CREATE USER 'investigador'@'localhost' IDENTIFIED BY 'invest789';
CREATE USER 'auditor'@'localhost' IDENTIFIED BY 'audit101';
CREATE USER 'encargado_visitantes'@'localhost' IDENTIFIED BY 'visit202';

-- Permisos para el administrador: Acceso total
GRANT ALL PRIVILEGES ON LosAmbientales.* TO 'administrador'@'localhost';

-- Permisos para el gestor de parques: Gestión de parques, áreas y especies
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.parque TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.area TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.especie TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.EspecieArea TO 'gestor_parques'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.departamentoParque TO 'gestor_parques'@'localhost';
GRANT SELECT ON LosAmbientales.departamento TO 'gestor_parques'@'localhost';
GRANT SELECT ON LosAmbientales.entidadResponsable TO 'gestor_parques'@'localhost';

-- Permisos para el investigador: Acceso a datos de proyectos y especies
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.proyectoInvestigacion TO 'investigador'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.especie TO 'investigador'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.EspecieProyecto TO 'investigador'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.investigadorProyecto TO 'investigador'@'localhost';
GRANT SELECT ON LosAmbientales.area TO 'investigador'@'localhost';
GRANT SELECT ON LosAmbientales.EspecieArea TO 'investigador'@'localhost';
GRANT SELECT ON LosAmbientales.personal TO 'investigador'@'localhost';

-- Permisos para el auditor: Acceso a reportes financieros
GRANT SELECT ON LosAmbientales.personal TO 'auditor'@'localhost';
GRANT SELECT ON LosAmbientales.proyectoInvestigacion TO 'auditor'@'localhost';
GRANT SELECT ON LosAmbientales.parque TO 'auditor'@'localhost';
GRANT SELECT ON LosAmbientales.area TO 'auditor'@'localhost';
GRANT SELECT ON LosAmbientales.especie TO 'auditor'@'localhost';
GRANT SELECT ON LosAmbientales.entidadResponsable TO 'auditor'@'localhost';
GRANT SELECT ON LosAmbientales.departamento TO 'auditor'@'localhost';

-- Permisos para el encargado de visitantes: Gestión de visitantes y alojamientos
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.visitante TO 'encargado_visitantes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.Alojamiento TO 'encargado_visitantes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.reservaAlojamiento TO 'encargado_visitantes'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON LosAmbientales.registroVisita TO 'encargado_visitantes'@'localhost';
GRANT SELECT ON LosAmbientales.parque TO 'encargado_visitantes'@'localhost';
GRANT SELECT ON LosAmbientales.entrada TO 'encargado_visitantes'@'localhost';
GRANT SELECT ON LosAmbientales.personalGestion TO 'encargado_visitantes'@'localhost';
GRANT SELECT ON LosAmbientales.personal TO 'encargado_visitantes'@'localhost';

-- Aplicar los cambios de permisos
FLUSH PRIVILEGES;

