using Oxygen
using HTTP
using Mustache

include.(filter(contains(r".jl$"), readdir("../Scripts/"; join=true)))

# Registrar carpeta static/
# staticfiles("/quasimetric/static", joinpath(@__DIR__, "static"))
staticfiles("static", "static")

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


@get "/vertices/{betweenness}" function (req::HTTP.Request, betweenness::Vector{String})
    return listvert(betweenness)
end

@get "/home" function (req::HTTP.Request)
    render_html("home.html")
end

@get "/norma1" function (req::HTTP.Request)
    render_html("norma1.html")
end

@get "/asymindex" function (req::HTTP.Request)
    render_html("asymindex.html")
end

@get "/quasimetric/" function (req::HTTP.Request)
    # Obtener los parámetros de consulta
    form_data = queryparams(req)
    betweenness = get(form_data, "betweenness", "")
    symmetry_option = get(form_data, "symmetry", "")
    
    betweenness = form_data["betweenness"]
    triples_list = map(s -> strip(String(s)), split(betweenness, ","))
    b_format = unique(map(String, triples_list))

    # Calcular quasimetric según la selección
    symtype = symmetry_option == "symmetric" ? sym() : nosym()
    modelo, valores_x, v = quasimetric(b_format, symtype)

    if modelo === nothing # Error de formato
        error_context = Dict(
            "error_message" => "El formato no es correcto, por favor entregue tríos.",
            "input_value" => betweenness
        )
        return render_html("n1_error.html", error_context)
    end

    if valores_x === nothing # Error de factibilidad
        error_context = Dict(
            "error_message" => "La betweenness proporcionada no es factible.",
            "input_value" => betweenness
        )
        return render_html("n1_error.html", error_context)
    end
    
    Q = [valores_x[i, :] for i in eachindex(v)]

    # Crear tabla HTML
    html_table = create_html_table(valores_x, v)
    
    creategraph(b_format, symtype; img_path="static/graph.png")

    # Contexto para renderizar el HTML
    # context = Dict(
    #     "input_triples" => join(unique(b_format), ", "),
    #     "vertices" => join(v, ", "),
    #     "html_table" => html_table
    # )

    context = Dict(
    "input_triples" => join(unique(b_format), ", "),
    "vertices" => join(v, ", "),
    "html_table" => html_table,
    "graph_image" => "static/graph.png"  # <-- clave para HTML
)

    
    # Renderizar la página de resultados
    return render_html("n1_result.html", context)
end

@get "/asimetria" function (req::HTTP.Request)
    form_data = queryparams(req)
    betweenness = get(form_data, "betweenness", "")

    if isempty(betweenness)
        return HTTP.Response(302, ["Location" => "/asymindex"])
    end

    triples_list = map(s -> strip(String(s)), split(betweenness, ","))
    b_format = unique(map(String, triples_list))

    modelo, valores_x, dif_x, v = ms(b_format)

    if modelo === nothing # Error de fomrato
        error_context = Dict(
            "error_message" => "El formato no es correcto, por favor entregue tríos.",
            "input_value" => betweenness
        )
        return render_html("ia_error.html", error_context)
    end

    if valores_x === nothing # Error de factibilidad
        error_context = Dict(
            "error_message" => "La betweenness proporcionada no es factible.",
            "input_value" => betweenness
        )
        return render_html("ia_error.html", error_context)
    end

    # Crear tablas HTML para mostrar las matrices de distancias y diferencias
    html_table_distancias = create_html_table(valores_x, v)
    html_table_diferencias = create_html_table(dif_x, v)

    # Contexto para renderizar el HTML
    context = Dict(
        "input_triples" => join(unique(b_format), ", "),
        "vertices" => join(v, ", "),
        "html_table_distancias" => html_table_distancias,
        "html_table_diferencias" => html_table_diferencias
    )

    # Renderizar resultados
    return render_html("ia_result.html", context)
end

serve()