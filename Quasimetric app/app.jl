using Oxygen
using HTTP
using Mustache
# using Dash
# using DashHtmlComponents
# const html = DashHtmlComponents
# using DashCoreComponents
# const dcc = DashCoreComponents
# using DashCytoscape
using Graphs

include.(filter(contains(r".jl$"), readdir("../Scripts/"; join=true)))

function render_html(html_file::String, context::Dict = Dict(); status = 200, headers = ["Content-Type" => "text/html; charset_utf-8"]) :: HTTP.Response
    is_context_empty = isempty(context) === true
    # return raw html without context
    if is_context_empty
        io = open(html_file, "r") do file
            read(file, String)
        end
        template = io |> String
    else 
        # Render html with context
        io = open(html_file, "r") do file
            read(file, String)
        end
        template = String(Mustache.render(io, context))
    end
    return HTTP.Response(status, headers, body = template)
end

@get "/vertices/{betweenness}" function (req::HTTP.Request, betweenness::Vector{String})
    return listvert(betweenness)
end

@get "/home" function (req::HTTP.Request)
    render_html("home.html")
end

function create_html_table(valores_x, v)
    table_rows = String[]
    for i in eachindex(v)
        row = "<tr><th>$(v[i])</th>" * join(["<td>$(round(valores_x[i, j], digits=2))</td>" for j in eachindex(v)], "") * "</tr>"
        push!(table_rows, row)
    end

    return """
    <table border="1" style="border-collapse: collapse; text-align: center; width: 100%;">
        <thead>
            <tr style="background-color: #f4f4f4;">
                <th></th>
                $(join(["<th>$(v[j])</th>" for j in eachindex(v)], ""))
            </tr>
        </thead>
        <tbody>
            $(join(table_rows, ""))
        </tbody>
    </table>
    """
end


@get "/quasimetric/" function (req::HTTP.Request)
    # Obtener los parámetros de consulta
    form_data = queryparams(req)
    
    # Procesar el parámetro betweenness
    if !haskey(form_data, "betweenness")
        return HTTP.Response(400, "Parámetro 'betweenness' faltante.")
    end
    
    betweenness = form_data["betweenness"]
    triples_list = map(s -> strip(String(s)), split(betweenness, ","))
    b_format = map(String, triples_list)

    modelo, valores_x, v = quasimetric(b_format)
    if valores_x === nothing
        error_context = Dict(
            "error_message" => "La betweenness proporcionada no es factible.",
            "input_value" => betweenness
        )
        return render_html("error.html", error_context)
    end
    
    Q = [valores_x[i, :] for i in eachindex(v)]

    # Crear tabla HTML
    html_table = create_html_table(valores_x, v)

    # Contexto para renderizar el HTML
    context = Dict(
        "input_triples" => join(triples_list, ", "),
        "vertices" => join(v, ", "),
        "html_table" => html_table
    )
    
    # Renderizar la página de resultados
    return render_html("result.html", context)
end

# function create_interactive_graph(B::Vector, html_file::String)
#     # Recibe la betweenness B y genera la página con el grafo interactivo
#     modelo, Q, V = quasimetric(B)
    
#     if Q === nothing
#         # Si no es factible, regresa un mensaje de error
#         error_context = Dict(
#             "error_message" => "La betweenness proporcionada no es factible."
#         )
#         return render_html("form.html", error_context)
#     else
#         optimize!(modelo)
#         n = length(V)  # Cantidad de vértices
        
#         # Crear lista de nodos
#         nodes = [Dict("data" => Dict("id" => string(i), "label" => string(V[i]))) for i in 1:n]

#         # Crear lista de aristas
#         edges = []
#         for i in eachindex(V)
#             for j in eachindex(V)
#                 if i != j
#                     # Agregar la arista con el peso como etiqueta
#                     push!(edges, Dict(
#                         "data" => Dict("source" => string(i), "target" => string(j), "label" => string(round(Q[i, j], digits=2)))
#                     ))
#                     if midpoint(B, i, j) == true
#                         # Remover la arista directa si hay un vértice intermedio
#                         pop!(edges)
#                     end
#                 end
#             end
#         end

#         # Crear grafo interactivo con Cytoscape
#         app = dash()

#         app.layout = html.div([
#             html.h1("Grafo Interactivo de Cuasimétrica"),
#             dcc.Input(
#                 id="betweenness-input",
#                 placeholder="Ingrese los tríos de betweenness...",
#                 type="text",
#                 value=join(B, ", ")
#             ),
#             DashCytoscape.cytoscape(
#                 id="cytoscape",
#                 style=Dict("width" => "100%", "height" => "600px"),
#                 elements=vcat(nodes, edges),
#                 layout=Dict("name" => "cose", "animate" => true),  # Layout interactivo
#                 stylesheet=[
#                     Dict("selector" => "node", "style" => Dict("label" => "data(label)", "background-color" => "#0074D9")),
#                     Dict("selector" => "edge", "style" => Dict("label" => "data(label)", "line-color" => "#FF4136", "width" => 2))
#                 ]
#             )
#         ])

#         # Iniciar el servidor Dash y mostrar el grafo
#         run_server(app, "0.0.0.0", 8050)
#     end
# end

serve(port=8001)