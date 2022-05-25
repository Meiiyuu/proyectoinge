import dash_core_components as dcc
import dash_html_components as html
import plotly.express as px
import pandas as pd
import psycopg2
from dash import Dash, dcc, html


def CasosRecuperadosByEtnias():
    return """select pe.nombre_etnia,  count(c.id)
            from etnia e INNER JOIN caso c ON (e.id_grupo = c.id_grupo_etnia)
						 INNER JOIN estado es ON (c.id_estado = es.id)
						 INNER JOIN estado_final ef ON (es.id_estado_final = ef.id)
		   				 inner join pertenencia_etnia as pe on (e.codigo_pertenencia_etnia=pe.codigo)
			WHERE ef.estado_final = 'Recuperado' 
            group by (pe.nombre_etnia)
			order by (count(c.id))"""

def ProbablesRecuperadosByEdad():
    return """select c.edad, ef.estado_final, count(c.id)
			from caso c INNER JOIN estado es ON (c.id_estado = es.id)
						INNER JOIN estado_final ef ON (es.id_estado_final = ef.id)
			group by (c.edad, ef.estado_final)
			order by edad asc"""

def TiempoRecuperacionByEdad():
    return """select  c.edad, AVG(extract(DAY FROM age(c.fecha_recuperacion,c.fecha_inicio_sintomas))) as tiempo_recuperacion, count(c.id)
			from caso c INNER JOIN medida_edad m ON (c.id_medida_edad = m.id)
			where m.unidad_medida = 'Anios'
			group by(edad)
			ORDER BY edad ASC"""

def ContagiosByMunicipio():
    return """select u.nombre_municipio, ef.estado_final, count(c.id)
			from ubicacion u INNER JOIN caso c ON (u.codigo_municipio = c.codigo_municipio_ubicacion)
						 INNER JOIN estado es ON (c.id_estado = es.id)
						 INNER JOIN estado_final ef ON (es.id_estado_final = ef.id)
			where ef.estado_final = 'Recuperado' or ef.estado_final =  'Fallecido'
			group by(u.nombre_municipio, ef.estado_final)
			order by(count(c.id)) desc"""

def RecuperadosFallecidosByAnho():
    return """select count(c.id), ef.estado_final, EXTRACT(YEAR FROM fecha_reporte) as anio
			from caso c INNER JOIN estado es ON (c.id_estado = es.id)
						INNER JOIN estado_final ef ON (es.id_estado_final = ef.id)
			where ef.estado_final = 'Recuperado' or ef.estado_final =  'Fallecido' and
			      EXTRACT(YEAR FROM fecha_reporte) = 2020 or EXTRACT(YEAR FROM fecha_reporte) = 2021
			group by(ef.estado_final, anio)
			order by (anio)"""
            


engine = None
resultDataFrame = None
try:
    print("Connecting...\n")

    engine = psycopg2.connect(user="postgres",
                                password="123456789",
                                database="proyecto",
                                host="localhost",
                                port="5432")

    
    query1 = CasosRecuperadosByEtnias()
    query2 = ProbablesRecuperadosByEdad()
    query3 = TiempoRecuperacionByEdad()
    query4 = ContagiosByMunicipio()
    query5 = RecuperadosFallecidosByAnho()
    out1 = pd.read_sql_query(query1, engine)
    out2 = pd.read_sql_query(query2, engine)
    out3 = pd.read_sql_query(query3, engine)
    out4 = pd.read_sql_query(query4, engine)
    out5 = pd.read_sql_query(query5, engine)
    print(out1)
    print(out2)
    print(out3)
    print(out4)
    print(out5)
    

    print("Disconnecting...\n")

    
except(Exception, psycopg2.DatabaseError) as error:
    print("Error:", error)
finally:
      if engine is not None:
          engine.close()

external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']
app = Dash(__name__, external_stylesheets=external_stylesheets)
app.title = 'Covid Cases'
server = app.server

fig1 = px.pie(out1, values = 'count', names = 'nombre_etnia')
fig2 = px.bar(out1, x = 'nombre_etnia', y = 'count')

fig3 = px.histogram(out2, x = 'edad', y = 'count', color = 'estado_final')
fig4 = px.pie(out2, names = 'estado_final')

fig5 = px.scatter(out3, x = 'edad', y = 'tiempo_recuperacion')
fig6 = px.bar(out3, x = 'edad', y = 'count')

fig7 = px.bar(out4.query("estado_final == 'Recuperado'"), x = 'nombre_municipio', y = 'count')
fig8 = px.bar(out4.query("estado_final == 'Fallecido'"), x = 'nombre_municipio', y = 'count')

fig9 = px.pie(out5.query("anio == 2020.0"), values = 'count', names = 'estado_final')
fig10 = px.pie(out5.query("anio == 2021.0"), values = 'count', names = 'estado_final')

colors = {
    'background': '#111111',
    'text': '#7FDBFF'
}

fig1.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig2.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig3.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig4.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig5.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig5.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig6.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig7.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig8.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig9.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

fig10.update_layout(
    plot_bgcolor = colors['background'],
    paper_bgcolor = colors['background'],
    font_color = colors['text']
)

app.layout = html.Div(style = {'backgroundColor': colors['background']}, children = [
    html.Br(),

    html.H1(children = '\n Covid Cases', style = {
        'textAlign': 'center',
        'color': colors['text']
    }),

    html.P(children = 'Casos Recuperados por Etnia', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'casosXetniaPie',
        figure = fig1
    ),

    html.Br(),

    html.P(children = 'Casos Recuperados por Etnia', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),
    
    html.Br(),

    dcc.Graph(
        id = 'casosXetniaBar',
        figure = fig2
    ),

    html.Br(),
    
    html.P(children = 'Casos Recuperados por Edad', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'ProbablesRecuperadosByEdad1',
        figure = fig3
    ),

    html.Br(),
    
    html.P(children = 'Edad más probable de recuperarse', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'ProbablesRecuperadosByEdad2',
        figure = fig4
    ),

    html.Br(),
    
    html.P(children = 'Tiempo promedio de recuperación por edad', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'TiempoRecuperacionByEdad1',
        figure = fig5
    ),

    html.Br(),
    
    html.P(children = 'Tiempo promedio de recuperación por edad', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'TiempoRecuperacionByEdad2',
        figure = fig6
    ),

    html.Br(),

    html.P(children = 'Contagios por Municipio', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'ContagiosByMunicipio1',
        figure = fig7
    ),

    html.Br(),
    
    html.P(children = 'Contagios fallecidos por Municipio', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'ContagiosByMunicipio2',
        figure = fig8
    ),

    html.Br(),

    html.P(children = 'Estado de casos en 2020', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'RecuperadosFallecidosByAnho1',
        figure = fig9
    ),

    html.Br(),
    
    html.P(children = 'Estado de casos en 2021', style = {
        'textAlign': 'left',
        'color': colors['text']
    }),

    html.Br(),

    dcc.Graph(
        id = 'RecuperadosFallecidosByAnho2',
        figure = fig10
    ),
])

if __name__ == '__main__':
    app.run_server(debug=True)



