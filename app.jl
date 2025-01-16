using Oxygen
using HTTP
using Mustache

include("Scripts/ListVert.jl")
include("Scripts/Format.jl")
include("Scripts/Quasimetric.jl")
# include.(filter(contains(r".jl$"), readdir("Scripts/"; join=true)))

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

@get "/quasimetric/{betweenness}" function (req::HTTP.Request, betweenness::Vector{String})
    qm, valores_x, v = quasimetric(betweenness)

    # No necesitas optimizar nuevamente, ya que el modelo fue optimizado dentro de quasimetric.
    # Si quieres optimizar el modelo fuera de la función, asegúrate de pasar solo el modelo:
    if qm !== nothing
        optimize!(qm)  # Llama a optimize! solo si necesitas optimizar de nuevo
    end
        
    tiempo_modelo= @elapsed (qm);
    tiempo_ejecucion = @elapsed (optimize!(qm));

    # println(String("Se tardó $tiempo_modelo segundos en crear el modelo y $tiempo_ejecucion en resolverlo"))
        
    # println(v)
    A = Vector[]
    # A[1] = v
    for i in eachindex(v)
        push!(A,valores_x[i,:])
    end
    return v, A
    end

serve(port=8001)