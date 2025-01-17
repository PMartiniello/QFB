using Oxygen
using HTTP
using Mustache

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


serve(port=8001)