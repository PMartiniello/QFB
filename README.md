# Quasimetric-from-betweenness
QFB.jl is a package made to help study the discrete quasimetric spaces spanned from betweenness. The betweenness is a ternary relation between vertices in a discrete space. For a betweenness $$\mathcal{B}$$ some points $$a, \ b$$ and $$c$$ are such that $$abc \in \mathcal{B}$$ if and only if $$d(a,b) + d(b,c) = d(a,c)$$.

For a certain betweenness $$\mathcal{B}$$ the quasimetric space $$Q(\mathcal{B})$$ that we study is the one that satisfies the following ILP:

$$\text{min } C$$

$$\text{st } \sum_{x, \ y \in V} Q_{x,y} \leq C$$

$$Q_{x, y} = 0 \ \iff x = y$$

$$Q_{x, y} + Q_{y, z} = Q_{x, z} \ \forall (x,y,z) \in \mathcal{B} $$

$$Q_{x, y} + Q_{y, z} \geq Q_{x, z} + 1 \ \forall (x,y,z) \notin \mathcal{B} $$ 

$$Q_{x,y} \in \mathbb{N}$$

Note that in this case, the ILP minimizes $$\lVert Q \rVert$$ <sub>1</sub> = $$\sum_{x,\ y \in V } Q_{x,y}$$.

Another function provided in the repository is a LP that penalizes the assymetry of $$Q(\mathcal{B})$$

$$\text{min }\sum_{x,y}D_{x,y}$$

$$\text{st } Q_{x,y} \leq D_{x,y}$$

$$Q_{x, y} = 0 \ \iff x = y$$

$$Q_{x, y} + Q_{y, z} = Q_{x, z} \ \forall (x,y,z) \in \mathcal{B} $$

$$Q_{x, y} + Q_{y, z} \geq Q_{x, z} + 1 \ \forall (x,y,z) \notin \mathcal{B} $$ 

$$D{x,y} = D{y,x} \forall x, y$$

A matrix $$Q(\mathcal{B})$$ that satisfies this will be a representation of the quasimetric with betweenness $$\mathcal{B}$$, minimizing a selected function.


$$Q(B)$$ can also be represented by a weighted digraph.

# Installation

Download the .zip with QFB-main and unzip it in any folder that you want. In your CMD search for the folder and run the command

```
julia --project=. app.jl
```

If everithing is installed correctly your CMD should display a message from Oxygen.jl about the server, something like this:
```
   ____
  / __ \_  ____  ______ ____  ____
 / / / / |/_/ / / / __ `/ _ \/ __ \
/ /_/ />  </ /_/ / /_/ /  __/ / / /
\____/_/|_|\__, /\__, /\___/_/ /_/
          /____//____/

[ Info: 📦 Version 1.6.0 (2025-01-10)
[ Info: ✅ Started server: http://127.0.0.1:8080
[ Info: 📖 Documentation: http://127.0.0.1:8080/docs
[ Info: 📊 Metrics: http://127.0.0.1:8080/docs/metrics
[ Info: Listening on: 127.0.0.1:8080, thread id: 1
```

With all of this you can use the app in your browser at http://127.0.0.1:8080/home

## Plotting solutions
The app plots a digraph $$D$$ such that $$\mathcal{B} = \mathcal{B}(Q(D))$$ in case of existing. A known error is that the browser might not update the plot for a different betweenness, which occurs because the images are saved with the same name as before, in order to avoid using too much unnecessary space, and the browsers temporal data might not update the new image. In any case, the most recent image can be found inside the folder QFB/Quasimetric app/static.
