using Graphs
using GraphPlot
using Compose
import Cairo, Fontconfig

function midpoint(B::Vector{String}, i::Int, j::Int)::Bool
    # Entrega un booleano indicando si existe un punto u tal que xuy está en la betweenness B
    V = listvert(B)
    for k in eachindex(V)
        #Para cada trío de vértices distintos verifica si estos tres están en la betweenness
        if V[i] * V[k] * V[j] in B
            return true
        end
    end
    #Si recorrió todos los vértices sin retornar entonces no existe un u tal que xuy está en B
    return false
end

function midpoint(B::Vector{Int64}, i::Int, j::Int)::Bool
    # Entrega un booleano indicando si existe un punto u tal que xuy está en la betweenness B
    v = listvert(B)
    for k in eachindex(v)
        #Para cada trío de vértices distintos verifica si estos tres están en la betweenness
        if v[i] * 100 + v[k] * 10 + v[j] in B
            return true
        end
    end
    #Si recorrió todos los vértices sin retornar entonces no existe un u tal que xuy está en B
    return false
end

function creategraph(B::Vector, symtype; img_path="static/graph.png")
    modelo, Q, V = quasimetric(B, symtype)
    if Q === nothing
        return nothing
    end

    optimize!(modelo)
    n = length(V)
    G = DiGraph()
    add_vertices!(G, n)
    elabels = []

    for i in eachindex(V)
        for j in eachindex(V)
            if i != j
                # Agrega la arista tentativamente
                add_edge!(G, i, j)
                push!(elabels, Q[i, j])

                # Si hay un vértice u tal que xuy ∈ B, se elimina la arista
                if midpoint(B, i, j)
                    rem_edge!(G, i, j)
                    pop!(elabels)
                end
            end
        end
    end

    # Generar el gráfico
    p = gplot(
        G,
        nodelabel=V,
        edgelabel=elabels,
        edgelabelc="red",
        linetype="curve",
        layout=circular_layout,
        outangle=0
    )

    # Guardar como PNG
    draw(PNG(img_path, 500px, 500px), p)

    return img_path
end
