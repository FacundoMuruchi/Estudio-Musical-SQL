from faker import Faker
import random
from datetime import timedelta

fake = Faker()
sql_statements = []

# 1. Artistas
for i in range(1, 101):
    nombre = fake.name().replace("'", "''")
    nacionalidad = fake.country()
    fecha = fake.date_of_birth(minimum_age=20, maximum_age=60)
    sql_statements.append(f"INSERT INTO Artistas VALUES ({i}, '{nombre}', '{nacionalidad}', '{fecha}');")

# 2. Productores
for i in range(1, 101):
    nombre = fake.name().replace("'", "''")
    experiencia = random.randint(1, 30)
    sql_statements.append(f"INSERT INTO Productores VALUES ({i}, '{nombre}', {experiencia});")

# 3. Estudios
for i in range(1, 101):
    nombre = f"Estudio {i}"
    ubicacion = fake.city()
    sql_statements.append(f"INSERT INTO Estudios VALUES ({i}, '{nombre}', '{ubicacion}');")

# 4. Álbumes
for i in range(1, 101):
    titulo = fake.unique.word().capitalize().replace("'", "''")
    anio = random.randint(2000, 2024)
    id_artista = random.randint(1, 100)
    sql_statements.append(f"INSERT INTO Albumes VALUES ({i}, '{titulo}', {anio}, {id_artista});")

# 5. Canciones
for i in range(1, 101):
    titulo = fake.bs().replace("'", "''").title()
    duracion = f"00:{random.randint(2, 5)}:{random.randint(0, 59):02d}"
    id_album = random.randint(1, 100)
    sql_statements.append(f"INSERT INTO Canciones VALUES ({i}, '{titulo}', '{duracion}', {id_album});")

# 6. Sesiones
for i in range(1, 101):
    fecha = fake.date_between(start_date='-3y', end_date='today')
    id_estudio = random.randint(1, 100)
    id_cancion = random.randint(1, 100)
    id_productor = random.randint(1, 100)
    sql_statements.append(f"INSERT INTO Sesiones VALUES ({i}, '{fecha}', {id_estudio}, {id_cancion}, {id_productor});")

# 7. Contratos
for i in range(1, 101):
    id_artista = random.randint(1, 100)
    id_productor = random.randint(1, 100)
    start = fake.date_between(start_date='-5y', end_date='-1y')
    end = start + timedelta(days=random.randint(180, 720))
    monto = round(random.uniform(1000, 10000), 2)
    sql_statements.append(f"INSERT INTO Contratos VALUES ({i}, {id_artista}, {id_productor}, '{start}', '{end}', {monto});")



for cancion_id in range(1, 101):
    generos = random.sample(range(1, 11), random.randint(1, 2))
    for genero_id in generos:
        sql_statements.append(f"INSERT INTO Cancion_Genero VALUES ({cancion_id}, {genero_id});")

for sesion_id in range(1, 101):
    instrumentos = random.sample(range(1, 11), random.randint(2, 4))
    for inst_id in instrumentos:
        sql_statements.append(f"INSERT INTO Sesion_Instrumento VALUES ({sesion_id}, {inst_id});")

for i in range(1, 51):
    id_cancion = random.randint(1, 100)
    id_artista = random.randint(1, 100)
    rol = random.choice(['vocalista', 'compositor', 'bajista', 'guitarrista'])
    sql_statements.append(f"INSERT INTO Colaboraciones VALUES ({id_cancion}, {id_artista}, '{rol}');")

for pago_id in range(1, 51):
    id_contrato = random.randint(1, 100)
    fecha = fake.date_between(start_date='-1y', end_date='today')
    monto = round(random.uniform(100, 1000), 2)
    sql_statements.append(f"INSERT INTO Pagos VALUES ({pago_id}, {id_contrato}, '{fecha}', {monto});")

for i in range(1, 101):
    id_sesion = i
    duracion = f"00:{random.randint(2,5)}:{random.randint(0,59):02d}"
    monto = round(random.uniform(1000, 10000), 2)
    instrumentos = random.randint(1, 5)
    sql_statements.append(f"INSERT INTO Hechos_Produccion VALUES ({i}, {id_sesion}, '{duracion}', {monto}, {instrumentos});")

# Exportar a archivo .sql
with open("estudio_musical_datos_Muruchi.sql", "w", encoding="utf-8") as f:
    f.write("\n".join(sql_statements))