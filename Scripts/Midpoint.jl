#Función auxiliar para ver cuáles vértices no se conectan directamente en el grafo
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
