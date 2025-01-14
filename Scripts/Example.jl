# This example only shows what the functions do, the visibility needs to be a function on it's own.

B = ["zwu", "uzw", "zwx", "xzw", "zwq", "qzw", "uxz", "zux", "uxw", "wux", "uxq", "qux", "quz", "zuq", "quw", "wuq", "qxz",
"zxq", "qxw", "wxq", "yxu", "xuy", "ywz", "wzy"] # Betweenness

modelo, valores_x, v = quasimetric(B)

# No necesitas optimizar nuevamente, ya que el modelo fue optimizado dentro de quasimetric.
# Si quieres optimizar el modelo fuera de la función, asegúrate de pasar solo el modelo:
if modelo !== nothing
    optimize!(modelo)  # Llama a optimize! solo si necesitas optimizar de nuevo
end
    
tiempo_modelo= @elapsed (modelo);
tiempo_ejecucion = @elapsed (optimize!(modelo));

println(String("Se tardó $tiempo_modelo segundos en crear el modelo y $tiempo_ejecucion en resolverlo"))
    
println(v)

for i in eachindex(v)
    println(v[i], valores_x[i,:])
end