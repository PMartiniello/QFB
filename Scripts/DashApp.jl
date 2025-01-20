# using Dash
# using PlotlyJS
# using Graphs
# using Mustache
# using HTTP

# include("Quasimetric.jl")
# include("ListVert.jl")
# include("Format.jl")
# include("Midpoint.jl")
# include("CreateGraph.jl")

# function app()
#     app = dash()

#     app.layout = html_div() do
#         div([
#             html_h1("Matriz Cuasimétrica"),
#             html_p("Tríos ingresados: {{input_triples}}"),
#             html_p("Vértices: {{vertices}}"),
#             dcc_graph(
#                 id="graph",
#                 figure=render_graph(creategraph([123,231,312]))
#             ),
#             html_a("Volver al formulario", href="http://127.0.0.1:8001/home")
#         ])
#     end
    
#     run_server(app, "127.0.0.1", 8050)
# end

# # Ejecutar la aplicación Dash
# app()