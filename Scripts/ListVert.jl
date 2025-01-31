function listvert(L::Vector{String})
    char = String[]
    for i in eachindex(L)
        # Dividir la cadena en caracteres y convertirlos a String
        a, b, c = map(String, split(L[i], ""))
        push!(char, a)
        push!(char, b)
        push!(char, c)
    end
    return unique(char)  # Eliminar caracteres repetidos
end

function listvert(L::Vector{Int64})
    vert = Int64[]
    for i in eachindex(L)
        u, d, c = digits(i) #unidad, decena, centena

        push!(vert, c)
        push!(vert, d)
        push!(vert, u)
    end
    return unique(vert)
end