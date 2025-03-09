-- In this document you will find the SQL code to create the tables and the keys between them into the database.

-- 1. Entidades responsables

CREATE TABLE entidadResponsable (
    idEntidadResponsable INT PRIMARY KEY AUTO_INCREMENT,
    nombreEntidadResponsable VARCHAR(100) NOT NULL
);

-- 2. Especies

CREATE TABLE especie (
    idEspecie INT PRIMARY KEY AUTO_INCREMENT,
    denominacionCientificaEspecie VARCHAR(100) NOT NULL UNIQUE,
    denominacionVulgarEspecie VARCHAR(100),
    tipo ENUM('vegetal', 'animal', 'mineral') NOT NULL
);

-- 3. Personal

CREATE TABLE personal (
    cedulaPersonal VARCHAR(20) PRIMARY KEY,
    nombrePersonal VARCHAR(100) NOT NULL,
    direccionPersonal VARCHAR(200),
    sueldoPersonal DECIMAL(10,2) NOT NULL,
    tipoPersonal ENUM('001','002','003','004') NOT NULL
);

-- 4. Departamentos

CREATE TABLE departamento (
    idDepartamento INT PRIMARY KEY AUTO_INCREMENT,
    nombreDepartamento VARCHAR(100) NOT NULL,
    idEntidadResponsable INT NOT NULL,
    FOREIGN KEY (idEntidadResponsable) REFERENCES entidadResponsable(idEntidadResponsable)
);

-- 5. Parques

CREATE TABLE parque (
    idParque INT PRIMARY KEY AUTO_INCREMENT,
    nombreParque VARCHAR(100) NOT NULL UNIQUE,
    fechaDeclaracionParque DATE NOT NULL
);

-- 6. Proyectos de investigación

CREATE TABLE proyectoInvestigacion (
    idProyectoInvestigacion INT PRIMARY KEY AUTO_INCREMENT,
    nombreProyectoInvestigacion VARCHAR(100) NOT NULL,
    presupuestoProyectoInvestigacion DECIMAL(15,2) NOT NULL,
    fechaInicioProyectoInvestigacion DATE NOT NULL,
    fechaFinProyectoInvestigacion DATE NOT NULL
);

-- 7. Departamentos-Parques 

CREATE TABLE departamentoParque (
    idDepartamento INT,
    idParque INT,
    PRIMARY KEY (idDepartamento, idParque),
    FOREIGN KEY (idDepartamento) REFERENCES departamento(idDepartamento),
    FOREIGN KEY (idParque) REFERENCES parque(idParque)
);

-- 8. Áreas

CREATE TABLE area (
    idArea INT PRIMARY KEY AUTO_INCREMENT,
    nombreArea VARCHAR(100) NOT NULL,
    extensionArea DECIMAL(10,2) NOT NULL,
    idParque INT NOT NULL,
    FOREIGN KEY (idParque) REFERENCES parque(idParque)
);

-- 9. Especies de cada área

CREATE TABLE EspecieArea (
    idEspecie INT,
    idArea INT,
    numeroInventarioEspecieArea INT NOT NULL,
    PRIMARY KEY (idEspecie, idArea),
    FOREIGN KEY (idEspecie) REFERENCES especie(idEspecie),
    FOREIGN KEY (idArea) REFERENCES area(idArea)
);

-- 10. Visitantes

CREATE TABLE visitante (
    cedulaVisitante VARCHAR(20) PRIMARY KEY,
    nombreVisitante VARCHAR(100) NOT NULL,
    direccionVisitante VARCHAR(200),
    profesionVisitante VARCHAR(100)
);

-- 11. Alojamientos

CREATE TABLE Alojamiento (
    idAlojamiento INT PRIMARY KEY AUTO_INCREMENT,
    nombreAlojamiento VARCHAR(100) NOT NULL,
    capacidadAlojamiento INT NOT NULL,
    categoriaAlojamiento ENUM('Económico','Medio','Lujo') NOT NULL,
    idParque INT NOT NULL,
    FOREIGN KEY (idParque) REFERENCES parque(idParque)
);

-- 12. Teléfonos del personal

CREATE TABLE telefonoPersonal (
    cedulaPersonal VARCHAR(20),
    telefonoPersonal VARCHAR(20),
    tipoTelefonoPersonal ENUM('Fijo','Móvil') NOT NULL,
    PRIMARY KEY (cedulaPersonal, telefonoPersonal),
    FOREIGN KEY (cedulaPersonal) REFERENCES personal(cedulaPersonal)
);

-- 13. Entradas de parques

CREATE TABLE entrada (
    idEntrada INT PRIMARY KEY AUTO_INCREMENT,
    numeroEntrada INT NOT NULL UNIQUE,
    idParque INT NOT NULL,
    FOREIGN KEY (idParque) REFERENCES parque(idParque)
);

-- 14. Personal de gestión

CREATE TABLE personalGestion (
    cedulaPersonalGestion VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (cedulaPersonalGestion) REFERENCES personal(cedulaPersonal)
);

-- 15. Vehículos de vigilancia

CREATE TABLE vehiculo (
    idVehiculo  INT PRIMARY KEY AUTO_INCREMENT,
    tipoVehiculo VARCHAR(50) NOT NULL,
    marcaVehiculo VARCHAR(50) NOT NULL
);

-- 16. Vigilantes-vehículos

CREATE TABLE vehiculoVigilante (
    cedulaPersonal VARCHAR(20),
    idVehiculo INT,
    fechaAsignacionVehiculoVisitante DATE NOT NULL,
    PRIMARY KEY (cedulaPersonal, idVehiculo),
    FOREIGN KEY (cedulaPersonal) REFERENCES personal(cedulaPersonal),
    FOREIGN KEY (idVehiculo) REFERENCES vehiculo(idVehiculo)
);

-- 17. Vigilancia de áreas

CREATE TABLE vigilanciaArea (
    cedulaPersonal VARCHAR(20),
    idArea INT,
    PRIMARY KEY (cedulaPersonal, idArea),
    FOREIGN KEY (cedulaPersonal) REFERENCES personal(cedulaPersonal),
    FOREIGN KEY (idArea) REFERENCES area(idArea)
);

-- 18. Conservación de áreas

CREATE TABLE conservacionArea (
    cedulaPersonal VARCHAR(20),
    idArea INT,
    especialidadConservacionArea VARCHAR(100) NOT NULL,
    PRIMARY KEY (cedulaPersonal, idArea),
    FOREIGN KEY (cedulaPersonal) REFERENCES personal(cedulaPersonal),
    FOREIGN KEY (idArea) REFERENCES area(idArea)
);

-- 19. Investigadores en proyectos

CREATE TABLE investigadorProyecto (
    cedulaPersonal VARCHAR(20),
    idProyectoInvestigacion INT,
    PRIMARY KEY (cedulaPersonal, idProyectoInvestigacion),
    FOREIGN KEY (cedulaPersonal) REFERENCES personal(cedulaPersonal),
    FOREIGN KEY (idProyectoInvestigacion) REFERENCES proyectoInvestigacion(idProyectoInvestigacion)
);

-- 20. Especies en proyectos

CREATE TABLE EspecieProyecto (
    idEspecie INT,
    idProyectoInvestigacion INT,
    PRIMARY KEY (idEspecie, idProyectoInvestigacion),
    FOREIGN KEY (idEspecie) REFERENCES especie(idEspecie),
    FOREIGN KEY (idProyectoInvestigacion) REFERENCES proyectoInvestigacion(idProyectoInvestigacion)
);

-- 21. Reservas de alojamiento

CREATE TABLE reservaAlojamiento (
    cedulaVisitante VARCHAR(20),
    idAlojamiento INT,
    fechaEntradaReservaAlojamiento DATE NOT NULL,
    fechaSalidaReservaAlojamiento DATE NOT NULL,
    PRIMARY KEY (cedulaVisitante, idAlojamiento, fechaEntradaReservaAlojamiento),
    FOREIGN KEY (cedulaVisitante) REFERENCES visitante(cedulaVisitante),
    FOREIGN KEY (idAlojamiento) REFERENCES alojamiento(idAlojamiento)
);

-- 22. Registro de visitas

CREATE TABLE registroVisita (
    idRegistroVisita INT PRIMARY KEY AUTO_INCREMENT,
    cedulaVisitante VARCHAR(20) NOT NULL,
    idEntrada INT NOT NULL,
    cedulaPersonalGestion VARCHAR(20) NOT NULL,
    fechaRegistroVisita DATETIME NOT NULL,
    FOREIGN KEY (cedulaVisitante) REFERENCES visitante(cedulaVisitante),
    FOREIGN KEY (idEntrada) REFERENCES entrada(idEntrada),
    FOREIGN KEY (cedulaPersonalGestion) REFERENCES personalGestion(cedulaPersonalGestion)
);
