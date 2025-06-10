CREATE DATABASE IF NOT EXISTS estudiomusical;
USE estudiomusical;

-- Tabla: Artistas
CREATE TABLE Artistas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(100),
    fecha_nacimiento DATE
);

-- Tabla: Productores
CREATE TABLE Productores (
    id_productor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    experiencia INT
);

-- Tabla: Estudios
CREATE TABLE Estudios (
    id_estudio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ubicacion VARCHAR(100)
);

-- Tabla: Álbumes
CREATE TABLE Albumes (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    año_lanzamiento INT,
    id_artista INT,
    FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista)
);

-- Tabla: Canciones
CREATE TABLE Canciones (
    id_cancion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    duracion TIME,
    id_album INT,
    FOREIGN KEY (id_album) REFERENCES Albumes(id_album)
);

-- Tabla: Sesiones
CREATE TABLE Sesiones (
    id_sesion INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE,
    id_estudio INT,
    id_cancion INT,
    id_productor INT,
    FOREIGN KEY (id_estudio) REFERENCES Estudios(id_estudio),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion),
    FOREIGN KEY (id_productor) REFERENCES Productores(id_productor)
);

-- Tabla: Contratos
CREATE TABLE Contratos (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_artista INT,
    id_productor INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    monto_total DECIMAL(10, 2),
    FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista),
    FOREIGN KEY (id_productor) REFERENCES Productores(id_productor)
);

-- Tabla auxiliar para logs
CREATE TABLE IF NOT EXISTS Sesion_Log (
  id_log INT AUTO_INCREMENT PRIMARY KEY,
  id_sesion INT,
  fecha_log DATETIME,
  FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion)
);

-- Tabla: Generos
CREATE TABLE Generos (
    id_genero INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tbla: Cancion_Genero N:M
CREATE TABLE Cancion_Genero (
    id_cancion INT,
    id_genero INT,
    PRIMARY KEY (id_cancion, id_genero),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion),
    FOREIGN KEY (id_genero) REFERENCES Generos(id_genero)
);

-- Tabla: Instrumentos
CREATE TABLE Instrumentos (
    id_instrumento INT PRIMARY KEY,
    nombre VARCHAR(50),
    tipo VARCHAR(50)
);

-- Tabla: Sesion_Instrumento
CREATE TABLE Sesion_Instrumento (
    id_sesion INT,
    id_instrumento INT,
    PRIMARY KEY (id_sesion, id_instrumento),
    FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion),
    FOREIGN KEY (id_instrumento) REFERENCES Instrumentos(id_instrumento)
);

-- Tabla: Colaboraciones
CREATE TABLE Colaboraciones (
    id_cancion INT,
    id_artista INT,
    rol VARCHAR(50), -- Ej: 'vocalista', 'compositor'
    PRIMARY KEY (id_cancion, id_artista),
    FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion),
    FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista)
);

-- Tabla: Pagos
CREATE TABLE Pagos (
    id_pago INT PRIMARY KEY,
    id_contrato INT,
    fecha_pago DATE,
    monto DECIMAL(10, 2),
    FOREIGN KEY (id_contrato) REFERENCES Contratos(id_contrato)
);

-- Tabla: Hechos_Produccion
CREATE TABLE Hechos_Produccion (
    id_hecho INT PRIMARY KEY,
    id_sesion INT,
    duracion_cancion TIME,
    monto_contrato DECIMAL(10,2),
    cantidad_instrumentos INT,
    FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion)
);


-- Vistas
CREATE OR REPLACE VIEW vista_resumen_sesiones AS
SELECT s.id_sesion, e.nombre AS estudio, c.titulo AS cancion, p.nombre AS productor
FROM Sesiones s
JOIN Estudios e ON s.id_estudio = e.id_estudio
JOIN Canciones c ON s.id_cancion = c.id_cancion
JOIN Productores p ON s.id_productor = p.id_productor;

CREATE OR REPLACE VIEW vista_contratos_activos AS
SELECT c.*, a.nombre AS artista, p.nombre AS productor
FROM Contratos c
JOIN Artistas a ON c.id_artista = a.id_artista
JOIN Productores p ON c.id_productor = p.id_productor
WHERE CURDATE() BETWEEN c.fecha_inicio AND c.fecha_fin;

CREATE OR REPLACE VIEW vista_artistas_albumes AS
SELECT a.nombre AS artista, al.titulo AS album
FROM Artistas a
JOIN Albumes al ON a.id_artista = al.id_artista;

CREATE VIEW vista_duracion_albumes AS
SELECT 
    al.titulo AS titulo_album,
    a.nombre AS nombre_artista,
    SEC_TO_TIME(SUM(TIME_TO_SEC(c.duracion))) AS duracion_total
FROM Albumes al
JOIN Canciones c ON al.id_album = c.id_album
JOIN Artistas a ON al.id_artista = a.id_artista
GROUP BY al.id_album, al.titulo, a.nombre;

CREATE VIEW vista_top_colaboraciones AS
SELECT 
    a.nombre AS nombre_artista,
    p.nombre AS nombre_productor,
    COUNT(*) AS cantidad_colaboraciones
FROM Contratos c
JOIN Artistas a ON c.id_artista = a.id_artista
JOIN Productores p ON c.id_productor = p.id_productor
GROUP BY a.nombre, p.nombre
ORDER BY cantidad_colaboraciones DESC;


-- Funciones
DELIMITER //
CREATE FUNCTION obtener_antiguedad_productor(prod_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE ant INT;
  SELECT experiencia INTO ant FROM Productores WHERE id_productor = prod_id;
  RETURN ant;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION canciones_por_album(album_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total INT;
  SELECT COUNT(*) INTO total FROM Canciones WHERE id_album = album_id;
  RETURN total;
END //
DELIMITER ;

-- Stored Procedures
DELIMITER //
CREATE PROCEDURE registrar_sesion(
  IN fecha DATE,
  IN id_estudio INT,
  IN id_cancion INT,
  IN id_productor INT
)
BEGIN
  INSERT INTO Sesiones(fecha, id_estudio, id_cancion, id_productor)
  VALUES (fecha, id_estudio, id_cancion, id_productor);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE actualizar_monto_contrato(
  IN contrato_id INT,
  IN nuevo_monto DECIMAL(10,2)
)
BEGIN
  UPDATE Contratos SET monto_total = nuevo_monto WHERE id_contrato = contrato_id;
END //
DELIMITER ;

-- Triggers
DELIMITER //
CREATE TRIGGER verificar_fechas_contrato
BEFORE INSERT ON Contratos
FOR EACH ROW
BEGIN
  IF NEW.fecha_inicio > NEW.fecha_fin THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'fecha_inicio no puede ser posterior a fecha_fin';
  END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER log_sesion_insert
AFTER INSERT ON Sesiones
FOR EACH ROW
BEGIN
  INSERT INTO Sesion_Log(id_sesion, fecha_log) VALUES (NEW.id_sesion, NOW());
END //
DELIMITER ;
