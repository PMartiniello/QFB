# Función para renderizar el grafo en una página HTML
using Dash
using PlotlyJS
using Graphs
using Mustache
using HTTP

function render_graph(G, elabels, V)
    # Aquí deberías crear una visualización del grafo, por ejemplo con PlotlyJS
    plot_data = []
    
    # Suponiendo que generas un layout circular
    node_x = [cos(2 * π * i / length(V)) for i in 1:length(V)]
    node_y = [sin(2 * π * i / length(V)) for i in 1:length(V)]
    
    # Crear los arcos (edges) como líneas
    for (i, j) in edges(G)
        push!(plot_data, scatter(
            x=[node_x[i], node_x[j]],
            y=[node_y[i], node_y[j]],
            mode="lines+text",
            line=attr(color="blue", width=2),
            text=["$i → $j", ""],
            textposition="middle center",
            textfont=attr(size=10)
        ))
    end
    
    layout = Layout(title="Digraph",
                    xaxis=attr(showgrid=false, zeroline=false),
                    yaxis=attr(showgrid=false, zeroline=false),
                    hovermode="closest",
                    showlegend=false)
    
    return plot(plot_data, layout)
end