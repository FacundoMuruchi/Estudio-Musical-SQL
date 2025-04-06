-- Crear base de datos
CREATE DATABASE IF NOT EXISTS estudiomusical;
USE estudiomusical;

-- Tabla: Artistas
CREATE TABLE Artistas (
    id_artista INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50),
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

SELECT * FROM Sesiones
