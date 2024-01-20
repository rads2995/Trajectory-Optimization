# Trajectory-Optimization
Large scale nonlinear optimization of continuous systems.


## How to Build
To get started, simply run the following commands on the terminal: 
```shell
docker build --rm --tag trajectory-optimization .
docker run --rm --interactive --tty --volume ${PWD}:/trajectory-optimization trajectory-optimization
```


## Sample Problem
Example problem number 71 from the Hock-Schittkowsky test suite:

$$
\begin{aligned}
\min_{x \in \mathbb{R}^{4}} \quad & x_{1}x_{4}(x_{1}+x_{2}+x_{3})+x_{3} \\
\textrm{s.t.} \quad & x_{1}x_{2}x_{3}x_{4} \geq 25 \\
& x_{1}^{2} + x_{2}^{2} + x_{3}^{2} + x_{4}^{2} = 40 \\
& 1 \leq x_{1},x_{2},x_{3},x_{4} \leq 5 \\
\end{aligned}
$$

with the starting point $$x_{0} = (1,5,5,1)$$

and the optimal solution $$x_{*}=(1.00000000,4.74299963,3.82114998,1.37940829).$$

### Interfacing with Ipopt through code
The following information is required by Ipopt:

1. Problem dimensions
    - number of variables
    - number of constraints
1. Problem bounds
    - variable bounds
    - constraint bounds
1. Initial starting point
    - Initial values for the primal $x$ variables
    - Initial values for the multipliers (only required for a warm start option)
1. Problem Structure
    - number of nonzeros in the Jacobian of the constraints
    - number of nonzeros in the Hessian of the Lagrangian function
    - sparsity structure of the Jacobian of the constraints
    - sparsity structure of the Hessian of the Lagrangian function
1. Evaluation of Problem Functions \
Information evaluated using a given point ( $x$, $\lambda$, $\sigma_{f}$ coming from Ipopt)
    - Objective function, $f(x)$
    - Gradient of the objective, $\Delta f(x)$
    - Constraint function values, $g(x)$
    - Jacobian of the constraints, $\Delta g(x)^{T}$
    - Hessian of the Lagrangian function, $$\sigma_{f}\nabla^{2}f(x)+\sum_{i=1}^{m}\lambda_{i}\nabla^{2}g_{i}(x)$$ \
    (this is not required if a quasi-Newton options is chosen to approximate the second derivatives)

The gradient of the objective $f(x)$ is given by 

$$
\begin{bmatrix}
x_{1}x_{4} + x_{4}(x_{1}+x_{2}+x_{3}) \\
x_{1}x_{4} \\
x_{1}x_{4} + 1 \\
x_{1}(x_{1}+x_{2}+x_{3})
\end{bmatrix}
$$

and the Jacobian of the constraints $g(x)$ is

$$
\begin{bmatrix}
x_{2}x_{3}x_{4} & x_{1}x_{3}x_{4} & x_{1}x_{2}x_{4} & x_{1}x_{2}x_{3}\\
2x_{1} & 2x_{2} & 2x_{3} & 2x_{4} \\
\end{bmatrix}
$$

The Lagrangian function for the NLP is dfined as $f(x) + g(x)^{T}\lambda$ and the Hessian of the Lagrangian function is, technically, $$\nabla^{2}f(x_{k})+\sum_{i=1}^{m}\lambda_{i}\nabla^{2}g_{i}(x_{k})$$

and for the problem this becomes

$$
\sigma_{f}\begin{bmatrix}
2x_{4} & x_{4} & x_{4} & 2x_{1} + x_{2} + x_{3} \\
x_{4} & 0 & 0 & x_{1} \\
x_{4} & 0 & 0 & x_{1} \\
2x_{1}+x_{2}+x_{3} & x_{1} & x_{1} & 0
\end{bmatrix}
+ 
\lambda_{1}\begin{bmatrix}
0 & x_{3}x_{4} & x_{2}x_{4} & x_{2}x_{3} \\
x_{3}x_{4} & 0 & x_{1}x_{4} & x_{1}x_{3} \\
x_{2}x_{4} & x_{1}x_{4} & 0 & x_{1}x_{2} \\
x_{2}x_{3} & x_{1}x_{3} & x_{1}x_{2} & 0
\end{bmatrix}
+
\lambda_{2}\begin{bmatrix}
2 & 0 & 0 & 0 \\
0 & 2 & 0 & 0 \\
0 & 0 & 2 & 0 \\
0 & 0 & 0 & 2 \\
\end{bmatrix}
$$

where the first term comes from the Hessian of the objective function, and the second and third term from the Hessian of the constraints. Therefore, the dual variables $\lambda_{1}$ and $\lambda_{2}$ are the multipliers for the constraints.
