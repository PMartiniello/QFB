using Graphs
function creategraph(B::Vector{String})
    #Recibe la betweenness B y entrega el grafo en caso de que sea factible
    modelo, Q, V = quasimetric(B)
    #Si es infactible no retorna nada
    if Q === nothing
        return nothing
    else
        optimize!(modelo)
        n = length(V) #Cantidad de vértices
        G = DiGraph() #Genera el digrafo
        add_vertices!(G, n) #Crea los vértices en el grafo
        elabels = []  # Lista para las etiquetas de las aristas

        for i in 1:n
            for j in 1:n
                if i != j
                    #Para cada par distinto de vértices agrega la arista con el peso dado por Q
                    add_edge!(G,i,j)
                    push!(elabels,Q[i,j])
                    if midpoint(B, i, j) == true
                        #Si hay un vértice entre estas dos aristas, entonces borra el camino directo
                        rem_edge!(G, i, j)
                        pop!(elabels)
                    end
                end
            end
        end
    end
    # Muestra la cuasimétrica Q
    tiempo_modelo= @elapsed (modelo);
    tiempo_ejecucion = @elapsed (optimize!(modelo));
    println(String("Se tardó $tiempo_modelo segundos en crear el modelo y $tiempo_ejecucion en resolverlo"))
    for i in getindex(V) #0:length(V)
        if i == 0
            print(V, "\n")
        else
            println(V[i], Q[i, :])
        end
    end
    # Grafica el grafo
    gplot(G, nodelabel=1:n, edgelabel=elabels, linetype="curve", layout=circular_layout,
        outangle=pi/7, background_color="grey", plot_size=(15cm, 15cm), pad=1cm)
end