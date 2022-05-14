import psycopg2
import pandas as pd

engine = None
resultDataFrame = None
try:
    print("Connecting...\n")

    engine = psycopg2.connect(user="postgres",
                                password="123456789",
                                database="proyecto",
                                host="localhost",
                                port="5432")

    tablas=["caso","estado","ubicacion","genero","medida_edad","localizacion", "etnia", "pertenencia_etnia", "tipo_contagio", "estado_final", "estado_durante"]
    for t in tablas:
        query = 'select * from {0}'.format(t)
        print(t) 
        tabla = pd.read_sql_query(query, engine)
        print(tabla)
        print()
        print()

    print("Disconnecting...\n")

    
except(Exception, psycopg2.DatabaseError) as error:
    print("Error:", error)
finally:
      if engine is not None:
          engine.close()
