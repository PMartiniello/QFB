using Combinatorics, ArgCheck

function format(B::Vector{String})
    # Recibe la betweenness como una lista con str de largo 3
    # Devuelve betweenness formateada con 3 str por elemento de la lista y los tríos que no están en la betweenness
    for b in B
        @argcheck(length(b) == 3)
    end

    v = listvert(B)
    
    # Genera la betweenness formateada
    F = Vector{String}[]
    for b in B
        # Convertimos SubString a String con map(String, ...)
        x, y, z = map(String, split(b, ""))
        push!(F, [x, y, z])
    end
    
    # Todas las permutaciones de tríos de vértices
    T = Vector{String}[]
    for p in permutations(v, 3)
        push!(T, p)
    end
    
    # Quita los que están en la betweenness
    for b in F
        T = filter!(n -> n != b, T)
    end
    
    return F, T
end