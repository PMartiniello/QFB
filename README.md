# Quasimetric-from-betweenness
QFB.jl is a package made to help study the discrete quasimetric spaces spanned from betweenness. The betweenness is a ternary relation between vertices in a discrete space. For a betweenness $B$ some points $$a, \ b$$ and $$c$$ are such that $$abc \in B$ if and only if $$d(a,b) + d(b,c) = d(a,c)$$.

For a certain betweenness $$B$$ the quasimetric $$Q(B)$$ that we study is the one that satisfies the following ILP:

$$\text{min } C$$

$$\text{st } \sum_{x, \ y \in V} Q_{x,y} \leq C$$

$$Q_{x, y} = 0 \ \iff x = y$$

$$Q_{x, y} + Q_{y, z} = Q_{x, z} \ \forall (x,y,z) \in B $$

$$Q_{x, y} + Q_{y, z} \geq Q_{x, z} + 1 \ \forall (x,y,z) \notin B $$ 

$$Q_{x,y} \in \mathbb{N}$$

Note that in this case, the ILP minimizes $$\lVert Q \rVert$$ <sub>1</sub> = $$\sum_{x,\ y \in V } Q_{x,y}$$.

Another function provided in the repository is a LP that penalizes the assymetry of $$Q(B)$$

$$\text{min }\sum_{x,y}D_{x,y}$$

$$\text{st } Q_{x,y} \leq D_{x,y}$$

$$Q_{x, y} = 0 \ \iff x = y$$

$$Q_{x, y} + Q_{y, z} = Q_{x, z} \ \forall (x,y,z) \in B $$

$$Q_{x, y} + Q_{y, z} \geq Q_{x, z} + 1 \ \forall (x,y,z) \notin B $$ 

$$D{x,y} = D{y,x} \forall x, y$$

A matrix $$Q(B)$$ that satisfies this will be a representation of the quasimetric with betweenness $B$, minimizing a selected function.

$$Q(B)$$ can also be represented by a weighted digraph. The display of that is still pending in this repository.