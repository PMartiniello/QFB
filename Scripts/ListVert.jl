function listvert(L::Vector{String})
    n = length(L)
    char = String[]
    for i in 1:n
        # Dividir la cadena en caracteres y convertirlos a String
        a, b, c = map(String, split(L[i], ""))
        push!(char, a)
        push!(char, b)
        push!(char, c)
    end
    char = unique(char)  # Eliminar caracteres repetidos
    return char
end