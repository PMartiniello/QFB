# Función para crear el grafo
function creategraph(B::Vector)
    modelo, Q, V = quasimetric(B)
    if Q === nothing
        return nothing
    else
        optimize!(modelo)
        n = length(V)
        G = DiGraph()
        add_vertices!(G, n)
        elabels = []  # Lista para las etiquetas de las aristas

        for i in eachindex(V)
            for j in eachindex(V)
                if i != j
                    add_edge!(G,i,j)
                    push!(elabels, Q[i,j])
                    if midpoint(B, i, j) == true
                        rem_edge!(G, i, j)
                        pop!(elabels)
                    end
                end
            end
        end
    end
    return G, elabels, V, Q
end