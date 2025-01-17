using Dash
using PlotlyJS
using Graphs
using Mustache
using HTTP

function app()
    app = dash()

    app.layout = html_div() do
        div([
            html_h1("Matriz Cuasimétrica"),
            html_p("Tríos ingresados: {{input_triples}}"),
            html_p("Vértices: {{vertices}}"),
            dcc_graph(
                id="graph",
                figure=render_graph(creategraph([1, 2, 3, 4])[1], creategraph([1, 2, 3, 4])[2], [1, 2, 3, 4])
            ),
            html_a("Volver al formulario", href="/home")
        ])
    end
    
    run_server(app, "127.0.0.1", 8050)
end

# Ejecutar la aplicación Dash
app()