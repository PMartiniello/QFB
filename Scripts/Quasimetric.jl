using JuMP, Clp 
function quasimetric(B)
    V = listvert(B)
    n = length(V)
    F, T = format(B)
    mimodelo = Model(Clp.Optimizer)
    set_silent(mimodelo)
    
    # Definir las variables
    @variable(mimodelo, 0<=C) # Norma 1
    @variable(mimodelo, x[i in V, j in V; i!=j] >=1) # Matriz de distancias

    # Definir la función objetivo, minimizar la norma 1
    @objective(mimodelo, Min, C)

    # Añadir las restricciones
    @constraint(mimodelo, norm1, sum(x[u,v] for v in V, u in V if u!=v) <= C) # La suma es menor que C
    @constraint(mimodelo, betweenness[f in F], x[f[1],f[2]] + x[f[2],f[3]] == x[f[1],f[3]]) # Betweenness son tríos degenerados
    @constraint(mimodelo, tineq[t in T], x[t[1],t[2]] + x[t[2],t[3]] >= x[t[1],t[3]] + 1) # Desigualdad triangular

    # Resolver el modelo
    optimize!(mimodelo)

    # Verificar el estado de la optimización
    status = termination_status(mimodelo)
    if status == MOI.OPTIMAL
        println("Solución óptima encontrada.")
        
        # Obtener el valor de C
        valor_C = value(C)
        println("Valor óptimo de C: ", valor_C)

        # Crear una matriz para almacenar los valores de x
        dist_x = zeros(length(V),length(V))
        for i in enumerate(V)
            for j in enumerate(V)
                if i[1]!=j[1]
                    dist_x[i[1],j[1]] = value(x[i[2],j[2]])
                else
                    dist_x[i[1],i[1]] = 0
                end
            end
        end

        # Devolver el modelo, las distancias y vértices
        return mimodelo, dist_x, V
    else
        println("No se encontró solución óptima. Estado: ", status)
        return mimodelo, nothing, nothing
    end
end