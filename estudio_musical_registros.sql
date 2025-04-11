USE estudiomusical;

-- Artistas
INSERT INTO Artistas (nombre, nacionalidad, fecha_nacimiento) VALUES
('Luis Fonsi', 'Puerto Rico', '1978-04-15'),
('Shakira', 'Colombia', '1977-02-02'),
('Bad Bunny', 'Puerto Rico', '1994-03-10'),
('Rosalía', 'España', '1992-09-25'),
('Dua Lipa', 'Reino Unido', '1995-08-22'),
('The Weeknd', 'Canadá', '1990-02-16'),
('Billie Eilish', 'Estados Unidos', '2001-12-18'),
('Harry Styles', 'Reino Unido', '1994-02-01'),
('Karol G', 'Colombia', '1991-02-14'),
('J Balvin', 'Colombia', '1985-05-07'),
('Maluma', 'Colombia', '1994-01-28'),
('Ozuna', 'Puerto Rico', '1992-03-13'),
('Nathy Peluso', 'Argentina', '1995-01-12'),
('Tini Stoessel', 'Argentina', '1997-03-21'),
('Trueno', 'Argentina', '2002-03-25'),
('Nicki Nicole', 'Argentina', '2000-08-25'),
('Duki', 'Argentina', '1996-06-24'),
('Bizarrap', 'Argentina', '1998-08-29'),
('Lali Espósito', 'Argentina', '1991-10-10'),
('Ysy A', 'Argentina', '1998-07-12');

-- Productores
INSERT INTO Productores (nombre, experiencia) VALUES
('Andrés Torres', 15),
('Mauricio Rengifo', 12),
('Tainy', 10),
('Tiny', 8),
('Pharrell Williams', 20);

INSERT INTO Productores (nombre, experiencia) VALUES
('FM', 7);

-- Estudios
INSERT INTO Estudios (nombre, ubicacion) VALUES
('Estudio A', 'Buenos Aires'),
('Estudio B', 'Miami'),
('Estudio C', 'Los Ángeles');

-- Álbumes
INSERT INTO Albumes (titulo, año_lanzamiento, id_artista) VALUES
('Vida', 2019, 1),
('El Dorado', 2017, 2),
('YHLQMDLG', 2020, 3),
('Motomami', 2022, 4),
('Future Nostalgia', 2020, 5),
('After Hours', 2020, 6);

INSERT INTO Albumes (titulo, año_lanzamiento, id_artista) VALUES
('She Dont Give a Fo', 2017, 17);

-- Canciones
INSERT INTO Canciones (titulo, duracion, id_album) VALUES
('Despacito', '00:03:47', 1),
('Chantaje', '00:03:17', 2),
('Safaera', '00:04:55', 3),
('Saoko', '00:03:10', 4),
('Levitating', '00:03:23', 5),
('Blinding Lights', '00:03:20', 6);

INSERT INTO Canciones (titulo, duracion, id_album) VALUES
('She Dont Give a Fo', '00:03:50', 7);

-- Sesiones
INSERT INTO Sesiones (fecha, id_estudio, id_cancion, id_productor) VALUES
('2023-05-10', 1, 1, 1),
('2023-06-14', 2, 2, 2),
('2023-07-01', 3, 3, 3),
('2023-08-22', 1, 4, 4),
('2023-09-30', 2, 5, 5),
('2023-10-15', 3, 6, 1);

-- Contratos
INSERT INTO Contratos (id_artista, id_productor, fecha_inicio, fecha_fin, monto_total) VALUES
(1, 1, '2023-01-01', '2024-01-01', 50000.00),
(2, 2, '2023-03-15', '2024-03-15', 60000.00),
(3, 3, '2022-06-10', '2023-06-10', 45000.00),
(4, 4, '2023-07-20', '2024-07-20', 70000.00),
(5, 5, '2023-09-01', '2024-09-01', 80000.00);

INSERT INTO Contratos (id_artista, id_productor, fecha_inicio, fecha_fin, monto_total) VALUES
(17, 6, '2025-01-01', '2027-01-01', 40400.00);

-- Actualizar productores
SET SQL_SAFE_UPDATES = 0;
UPDATE Contratos
SET id_productor = CASE id_productor
    WHEN 1 THEN 3
    WHEN 2 THEN 1
    WHEN 3 THEN 4
    WHEN 4 THEN 5
    WHEN 5 THEN 2
    ELSE id_productor
END;
SET SQL_SAFE_UPDATES = 1;

-- Actualizar monto total
SET SQL_SAFE_UPDATES = 0;
UPDATE Contratos
SET monto_total = CASE monto_total
    WHEN 50000.00 THEN 260000.50
    WHEN 60000.00 THEN 453000.23
    WHEN 45000.00 THEN 703000.00
    WHEN 70000.00 THEN 625000.00
    WHEN 80000.00 THEN 1000000.00
    ELSE monto_total
END;
SET SQL_SAFE_UPDATES = 1;