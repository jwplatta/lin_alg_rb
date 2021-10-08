# Linear Algebra

The two fundamental objects of linear algebra are **points** and **vectors**.

A **point** is a location in place represented by an ordered set of coordinates, e.g. $(x, y)$.

A **vector** is an object representing a change in location and has a magnitude and a direction. Given a Euclidean coordinate system, a vector can be represented as the amount of change in a given direction, i.e. the slope of a line:
$$
\begin{bmatrix}
2 \\
-3
\end{bmatrix}
$$

## Vector Addition and Subtraction

$$
\begin{bmatrix}
5 \\
13
\end{bmatrix}
+
\begin{bmatrix}
8 \\
2
\end{bmatrix}
=
\begin{bmatrix}
13 \\
15
\end{bmatrix}
$$

$$
\begin{bmatrix}
5 \\
13
\end{bmatrix}
-
\begin{bmatrix}
8 \\
2
\end{bmatrix}
=
\begin{bmatrix}
-3 \\
11
\end{bmatrix}
$$

## Vector Scalar Multiplication

$$
\begin{bmatrix}
3 \\
7
\end{bmatrix}
*
0.5
=
\begin{bmatrix}
1.5 \\
3.5
\end{bmatrix}
$$

## Vector Magnitude and Direction

The **magnitude** of a vector is the distance between two points. We can find the distance using the Pythagorean theorem. Consider the vector:
$$
\vec{V} = \begin{bmatrix}
3 \\
4
\end{bmatrix}
$$

The magnitude of $\vec{V}$ is $\vert\vert \vec{V} \vert\vert$. It is the square root of the sum of the coordinates of $\vec{V}$:
$$
\vert\vert \vec{V} \vert\vert = \sqrt{3^2 + 4^2} = 5
$$

Finding the magnitude of a vectors can be generalized to:
$$
{\vert\vert \vec{V} \vert\vert}_2 = \sqrt{{v_1}^2 + {v_1}^2 + ... +  {v_n}^2}
$$

The magnitude of a vector is also called the **norm**. Since the square root is used, the above norms are called the **Euclidean norms**.

A **unit vector** is a vector whose magnitude is 1. A vector's *direction* is represented by its unit vector.

**Normalization** is the process of finding a unit vector in the same direction of a given vector. The normalization of a vector $V$ has two steps:
$$
\frac{1}{\vert\vert \vec{V} \vert\vert} \cdot \vec{V}
$$
1. Find the magnitude of $V$.
2. Multiply $V$ by the scalar 1 over the magnitude of $V$

## Zero Vector

**TODO**

## Inner Product (Dot Product)

The **inner product** enables us to find the angle between two vectors. The inner product of two vectors is a number, *not* another vector.

$$
\vec{v} \cdot \vec{w} = v_1w_1 + v_2w_2 + ... v_nw_n
$$

## Projecting Vectors

Every (non-zero) vector can be decomposed into a vector that's parallel to a basis vector and a vector that's orthogonal to a basis vector:
$$
\vec{v} = \vec{v}^{\parallel} + \vec{v}^{\bot}
$$

In order to compute the projection of a vector $\vec{v}$ onto a *basis vector* $\vec{b}$, find the component vector of $\vec{v}$ that is parallel to $\vec{b}$.

$$
\vert\vert \vec{v}^{\parallel} \vert\vert = \vert\vert \vec{v} \vert\vert \text{ cos}(\theta)
$$

Note that $\theta$ is the angle between $\vec{v}$ and $\vec{v}^{\parallel}$.

$$
\vert\vert \vec{v}^{\parallel} \vert\vert = \vec{v} \cdot \vec{u}_{\vec{b}}
$$

Note that $\vec{u}_{\vec{b}}$ is the unit vector in the direction of $\vec{b}$.

To get the vector $\vec{v}^{\parallel}$, simply scale the normalization (unit vector) of $\vec{b}$, i.e. $\vec{u}_{\vec{b}}$, by the magnitude of $\vec{v}^{\parallel}$:

$$
\vert\vert \vec{v}^{\parallel} \vert\vert \cdot \vec{u}_{\vec{b}} = \vec{v}^{\parallel}
$$

Then plugging in the above:

$$
\vec{v}^{\parallel} = (\vec{v} \cdot \vec{u}_{\vec{b}}) \cdot \vec{u}_{\vec{b}}
$$

## Cross Product

The **cross product** of two vectors $\vec{v}$ and $\vec{w}$ is a vector that's orthogonal to both $\vec{v}$ and $\vec{w}$.

The formula for $\vec{v} \textbf{ x } \vec{w}$:

If $\vec{v}$ is
$$
\begin{bmatrix}
x_1 \\
y_1 \\
z_1
\end{bmatrix}
$$
And $\vec{w}$ is
$$
\begin{bmatrix}
x_2 \\
y_2 \\
z_2
\end{bmatrix}
$$
Then $\vec{v} \textbf{ x } \vec{w}$ equals
$$
\begin{bmatrix}
y_1z_2 - y_2z_1 \\
-(x_1z_2 - x_2z_1) \\
x_1y_2 - x_2y_1
\end{bmatrix}
$$

You can check the results ensuring that the cross product multiplied by one of the original vectors is equal to zero (given the definition of orthogonality above).

## Parallel and Orthogonal Vectors

Two vectors $\vec{v}$ and $\vec{w}$ are **parallel** if one is a scalar multiple of the other. For example, $\vec{v}$ is parallel to $2\vec{v}$, $\frac{1}{2}\vec{v}$, and $-\vec{v}$.

Two vectors $\vec{v}$ and $\vec{w}$ are **orthogonal** if their dot product is equal to zero.

## Intersections

### Lines
A lines in two dimensions is defined by two properties:
- **Basepoint** A point the line passes through.
- **Direction vector** The vector that gives the direction of the line.

Recall the formula for a line $y = \text{m}x + \text{b}$ where $\text{m}$ is the slope of the line and $\text{b}$ is the y-intercept. The basepoint of the line is $(0, \text{b})$ and the direction vector is $\begin{bmatrix} 1 \\ \text{m} \end{bmatrix}$.

All points on the line can be represented as $\vec{x}(t) = \vec{x}_0 + t\vec{v}$. This expression is a **parameterization** of the line. Given any number $t$ we can find a point on the line.

A **standard form** of the equation for a line is
$$
\text{A}x + \text{B}y = k
$$
where A and B are not both zero. Possible basepoints:

if $B \neq 0$, then take $x=0$ to get $y = \frac{k}{\text{B}}$ which gives the basepoint $(0, \frac{k}{\text{B}})$

if $A \neq 0$, then take $y=0$ to get $x = \frac{k}{\text{A}}$ which gives the basepoint $(\frac{k}{\text{A}}, 0)$

The point $(x, y)$ is on the line $\text{A}x + \text{B}y = 0$ if and only if $\begin{bmatrix} x \\ y \end{bmatrix}$ is orthogonal to $\begin{bmatrix} \text{A} \\ \text{B} \end{bmatrix}$. This means we can find a direction vector for the line by finding some vector that's orthogonal to $\begin{bmatrix} \text{A} \\ \text{B} \end{bmatrix}$. One hackey way to do this is two swap the coordinates and negate one, e.g. $\begin{bmatrix} \text{B} \\ -\text{A} \end{bmatrix}$.

This formula for a line gives us an implicit representation of the line as a single equation, i.e. as the set points $(x, y)$ such that a vector $\begin{bmatrix} \text{A} \\ \text{B} \end{bmatrix}$ dotted with those coordinates equals a given number $k$. You can also easily read of the coordinates for a vector that's orthogonal to the line, i.e. $\begin{bmatrix} \text{A} \\ \text{B} \end{bmatrix}$. This orthogonal vector is call a **normal vector** of the line.

$$
\begin{bmatrix}
\text{A} \\
\text{B}
\end{bmatrix}
\cdot
\begin{bmatrix}
x \\
y
\end{bmatrix}
= k
$$

Two lines are parallel if their *normal vectors are parallel*.

Two parallel lines are equal if and only if the vector connecting one point on each line is orthogonal to the line's normal vectors.

To find the intersection of two non-parallel lines $\text{A}x + \text{B}y = k_1$ and $\text{C}x + \text{D}y = k_2$:
$$
x = \frac{\text{D}k_1 - \text{B}k_2}{\text{A}\text{D} - \text{B}\text{C}}
\text{ , }
y = \frac{-\text{C}k_1 + \text{A}k_2}{\text{A}\text{D} - \text{B}\text{C}}
$$

**Inconsistent** lines are lines that have no common point of intersection.

### Planes

The standard form of the equation for a plane is
$$
\text{A}x + \text{B}y + \text{C}z = \text{k}
$$
or
$$
\begin{bmatrix}
\text{A} \\
\text{B} \\
\text{C}
\end{bmatrix}
\cdot
\begin{bmatrix}
x \\
y \\
z
\end{bmatrix}
= \text{k}
$$

Vectors from the orign $(0, 0, 0)$ to points $(x, y, z)$ on the plane are orthogonal to the vector $\begin{bmatrix} \text{A} \\ \text{B} \\ \text{C} \end{bmatrix}$. This makes $\begin{bmatrix} \text{A} \\ \text{B} \\ \text{C} \end{bmatrix}$ a *normal vector* to the plane. Changing the value of the constant term $\text{k}$ shifts the plane, but does not change the direction of the plane.

Two planes are *parallel* if their normal vectors are parallel.

Two planes are *equal* if and only if the vector connecting one on each plane is orthogonal to the planes' normal vectors.

### Gaussian Elimination

The basic idea of Gaussian Elimination is to remove variables from successive equations in a system of equations.

For example, consider:
$$
\begin{split}
x - 3y + z = 4 \\
-3x + 9y + z = 0 \\
y - z = 1
\end{split}
$$
To solve this system of equations, first add 3 times the 1st equation to the 2nd equation in order to eliminate the $x$ and $y$ from the 2nd equation:
$$
\begin{split}
x - 3y + z = 4 \\
4z = 12 \\
y - z = 1
\end{split}
$$
Then swap the 2nd and 3rd equations in order to get an equation with a $y$ in the second row:
$$
\begin{split}
x - 3y + z = 4 \\
y - z = 1 \\
4z = 12
\end{split}
$$
There are no terms below the $z$ term in the last equation. So you can begin solving for each variable. Also note the triangular form of the system of equations. This is also called **row echelon form**. Also, note that the new system of equations do not represent the same planes as the original system of equations.

To start clearing the variables, first solve for $z$ in the bottom row:
$$
\begin{split}
x - 3y + z = 4 \\
y - z = 1 \\
z = 3
\end{split}
$$
Then add the 3rd equation to the 2nd equation:
$$
\begin{split}
x - 3y + z = 4 \\
y = 4 \\
z = 3
\end{split}
$$
Then subract the 3rd equation from the 1st equation:
$$
\begin{split}
x - 3y = 1 \\
y = 4 \\
z = 3
\end{split}
$$
Finally, to solve for the $x$ term, add 3 times the 2nd equation to the 1st equation:
$$
\begin{split}
x = 13 \\
y = 4 \\
z = 3
\end{split}
$$
The common point of intersection of the three planes described by the original system of equations is $(13, 4, 3)$.

Here is a another example with just the operations:
$$
\begin{split}
-x + y + z = -2 \\
x - 4y + 4z = 21 \\
7x - 5y - 11z = 0
\end{split}
$$
Eliminate the $x$ term:
$$
\begin{split}
-x + y + z = -2 \\
-3y + 5z = 19 \\
2y - 4z = -14
\end{split}
$$
Eliminate the $y$ term:
$$
\begin{split}
-x + y + z = -2 \\
-3y + 5z = 19 \\
-\frac{2}{3}z = -\frac{4}{3}
\end{split}
$$
Solve for $z$:
$$
\begin{split}
-x + y + z = -2 \\
-3y + 5z = 19 \\
z = 2
\end{split}
$$
Solve for $y$:
$$
\begin{split}
-x + y + z = -2 \\
-3y + 5z = \frac{19 - 10}{-3} = -3 \\
z = 2
\end{split}
$$
Solve for $x$:
$$
\begin{split}
x = 1 \\
y = -3 \\
z = 2
\end{split}
$$

Note that for a system of equations to have a unique solution, each variable must be in a leading position in an equation in the system. This is not always the case and so some systems of equations will not have a unique solution. In some cases, there is *no solution* and, in other cases, a system might have *more than one solution*.

A system of equations is **inconsistent** when the system has no solutions. In other words, the planes in the system do not have a common point of intersection. For example, this system of equations is inconsistent:
$$
\begin{split}
x + 2y + 3z = 1 \\
3x + 2y + z = 0 \\
7x + 6y + 5z = 2
\end{split}
$$

In order to discover that this system is inconsistent, apply the same procedure as before. First assume the system has a solution. Second, perform the operations to eliminate the terms until a contradiction is obtained:

Clear the $x$ term:
$$
\begin{split}
x + 2y + 3z = 1 \\
-4y - 8z = -3 \\
-8y - 16z = -5
\end{split}
$$
Next clear the $y$ term:
$$
\begin{split}
x + 2y + 3z = 1 \\
-4y - 8z = -3 \\
0 = 1
\end{split}
$$
And here we see a contradictino is derived which indicates the system has no solution.

A system of equations might also have more than one solution. For example, the below system has more than one solution:
$$
\begin{split}
x + 2y + 3z = 1 \\
3x + 2y + z = 0 \\
7x + 6y + 5z = 1
\end{split}
$$
First eliminate the $x$ term:
$$
\begin{split}
x + 2y + 3z = 1 \\
-4y - 8z = -3 \\
-8y - 16z = -6
\end{split}
$$
Then eliminate the $y$ term:
$$
\begin{split}
x + 2y + 3z = 1 \\
-4y - 8z = -3 \\
0 = 0
\end{split}
$$
Here we find that the system has a redundant row $0 = 0$ that can be dropped:
$$
\begin{split}
x + 2y + 3z = 1 \\
-4y - 8z = -3
\end{split}
$$
This system of equations only has two planes in it which means that the planes do not intersect at a single point if they intersect at all. In this case, the solution set is parameterized, i.e. all the points in the solution set are described as a function of some parameters.

In order to parameterize the solution set, first notice that no more terms can be cleared from this system. Instead, identify the pivot variables whose values will be determined by the free variables. A **pivot variable** is a variable that is in a leading position once the system is in triangular form. In the above case, the leading terms are $x$ and $y$. So these are the pivot variables which leaves $z$ as the free variable. The **free variables** are the parameters of the parameterized solution set. The number of free variables determines the dimension of the solution set.

First make the pivot variable in the second row have a coefficient of 1:
$$
\begin{split}
x + 2y + 3z = 1 \\
y + 2z = \frac{3}{4}
\end{split}
$$

Next clear the $y$ term from the first row by subtracting 2 times the 2nd equation from the 1st equation:
$$
\begin{split}
x - z = -\frac{1}{2} \\
y + 2z = \frac{3}{4}
\end{split}
$$
The system is now in **reduced row-echelon form**: the equations are in triangular form and each pivot variable has a coefficient of 1 and is in its own column.

Finally parameterize the solution set:

$$
\begin{bmatrix}
x \\
y \\
z
\end{bmatrix}
= \begin{bmatrix}
-\frac{1}{2} + z \\
\frac{3}{4} - 2z \\
z
\end{bmatrix}
= \begin{bmatrix}
-\frac{1}{2} \\
\frac{3}{4} \\
0
\end{bmatrix}
+
z
\begin{bmatrix}
1 \\
-2 \\
1
\end{bmatrix}
$$

This equality means that for every value of z, the point $(x, y, z)$ is in the solution set. Moreover, the last part of the equality expresses the solution set as line giving the basepoint and a direction vector.

A consistent system of equations has a unique solution if and only if each variable is a pivot variable.

### Extending to Higher Dimensions

A **hyperplane** in $n$ dimensions is defined by a single linear equation in $n$ variables. A hyperplane in $n$ dimensions is an $(n-1)$ dimensional object.

## Matrix Math
A **matrix** is a two-dimensional grid with m rows and n columns. Take a look at this matrix, which is a little larger than the examples so far.

In matrix addition and subtraction, you took an element from the first matrix, found the matching element in the second matrix, and outputted the sum or difference.

In *element-wise* multiplication of matrices, matching elements in a matrix are multiplied.

*Matrix multiplication* involves taking a row in matrix A and finding the dot product with a column in matrix B. Matrix multiplication is only possible if the number of columns in matrix $\textbf{A}$ is equal to the number of rows in matrix $\textbf{B}$. So, if matrix $\textbf{A}$ has shape $m \text{ x } n$ and matrix $\textbf{B}$ has shape $n \text{ x } p$, then the result of $\textbf{A} \text{ x } \textbf{B}$ will have shape $m \text{ x } p$.

A formal definition of multiplying two matrices:
$$
(\textbf{A}\textbf{B})_{ij} = \sum_{k=1}^na_{ik}b_{kj}
$$
In order to find the value of the $(i,j)$ element in the resulting matrix:
1. Take row $i$ in matrix $\textbf{A}$ and column $j$ in $\textbf{B}$
2. Do element-wise multiplication on the $i$-row $\textbf{A}$ vector and $j$-column $\textbf{B}$ vector.
3. Sum the resulting elements.

In short, matrix multiplication is really the dot product of the  $i$-row of vector $\textbf{A}$ and $j$-column of vector $\textbf{B}$.

You can think of the **tranpose** as switching rows and columns. The matrix rows become the columns or alternatively you can consider the columns become the rows.

The** identity matrix** $\textbf{I}$ is an $n \text{ x } n$ square matrix with 1 across the main diagonal and 0 for all other elements.

It turns out, that any matrix $\textbf{A}$ times the identity matrix is equal to itself: $\textbf{A}\textbf{I} = \textbf{I}\textbf{A} = \textbf{A}$.

The inverse of a matrix $\textbf{A}$ would be denoted $\textbf{A}^{-1}$. If a matrix has an inverse, then $\textbf{A} \text{ x } \textbf{A}^{-1} = \textbf{A}^{-1} \text{ x } \textbf{A} = \textbf{I}$ where $\textbf{I}$ is the identity matrix. Only square matrices have inverses.

### Kalman Filters
**Predication Step Equations**
Predict state vector and error covariance matrix:
$$
\hat{\textbf{x}}_k = \textbf{F}\hat{\textbf{x}}_{k-1}
$$
$$
\textbf{P}_{k-1} = \textbf{F}_k\textbf{P}_{k-1}\textbf{F}_{k}^{\intercal} + \textbf{Q}_k
$$

**Update Step Equations**
Kalman gain:
$$
\textbf{S}_k = \textbf{H}_k\textbf{P}_{k-1}\textbf{H}_{k}^{\intercal} + \textbf{R}_k
$$
$$
\textbf{K}_k = \textbf{P}_{k-1}\textbf{H}_{k}^{\intercal}\textbf{S}_{k}^{-1}
$$

Update State Vector and Error Covariance Matrix:
$$
\tilde{\textbf{y}}_k = \textbf{z}_k - \textbf{H}\hat{\textbf{x}}_{k-1}
$$
$$
\hat{\textbf{x}}_k = \hat{\textbf{x}}_{k-1} + \textbf{K}_{k}\tilde{\textbf{y}}_k
$$
$$
\textbf{P}_k = (\textbf{I} - \textbf{K}_k\textbf{H}_k)\textbf{P}_{k-1}
$$

**Variable Definitions**

$\hat{\textbf{x}}$ state vector
$\textbf{F}$ state transition matrix
$\textbf{P}$ error covariance matrix
$\textbf{Q}$ process noice covariance matrix
$\textbf{R}$ measurement noise covariance matrix
$\textbf{S}$ intermediate matrix for calculating Kalman gain
$\textbf{H}$ observation matrix
$\textbf{K}$ Kalman gain
$\tilde{\textbf{y}}$ difference between predicated state and measure state
$\textbf{z}$ measurement vector
$\textbf{I}$ identity matrix


**Predict**

Predicated *a priori* state estimate:
$$
\hat{\textbf{x}} = \textbf{F}\hat{\textbf{x}} + \textbf{B}u
$$

Predicated *a priori* state estimate covariance:
$$
\textbf{P} = \textbf{F}\textbf{P}\textbf{F}^{\intercal} + \textbf{Q}
$$

**Update**

Innovation or measurement pre-fit residual:
$$
\tilde{\textbf{y}} = \textbf{z} - \textbf{H}\hat{\textbf{x}}
$$

Innovation covariance:
$$
\textbf{S} = \textbf{H}\textbf{P}\textbf{H}^{\intercal} + \textbf{R}
$$

Optimal Kalman gain:
$$
\textbf{K} = \textbf{P}\textbf{H}^{\intercal}\textbf{S}^{-1}
$$

Updated *a posteriori* state estimate:
$$
\hat{\textbf{x}}_k = \hat{\textbf{x}}_{k-1} + \textbf{K}_{k}\tilde{\textbf{y}}_k
$$

Updated *a posteriori* estimate covariance:
$$
\textbf{P}_k = (\textbf{I} - \textbf{K}_k\textbf{H}_k)\textbf{P}_{k-1}
$$

Measurement post-fit residual:
$$
\tilde{\textbf{y}} = \textbf{z} - \textbf{H}\hat{\textbf{x}}
$$

### Eigenvectors

## Notes from Textbook
A **scalar** is a single number usually represented as a lowercase, italicized letter, e.g. "$s \in \mathbb{R}$" or "$n \in \mathbb{N}$".

A **vector** is an array of numbers where the numbers are arranged in order. Vectors are given lowercase names in bold, italicized letters, e.g. $\textbf{\textit{x}}$. Think of vectors as identifying a point in space.

A **matrix** is a 2-D array of numbers where each number is identified by two indices. Matrices are represented as bold, uppercase letters, e.g. $\textbf{A}$. $\textit{m}$ indicates the height of the matrix and $\textit{n}$ indicates the width.

$$
\begin{bmatrix}
A_{1,1} & A_{1,2} \\
A_{2,1} & A_{2,2}
\end{bmatrix}
$$

A **tensor** is an array with more than two axes. The element at coordinates $(\textit{i,j,k})$ in tensor $\textsf{A}$ is represented as $\textsf{A}_{\textit{i,j,k}}$.

The **transpose** of a matrix is the mirror image of a matrix across the **main diagonal** (the diagonal starting in the upper left and running to lower right corner). The transpose of matrix $\textbf{A}$ is represented as $\textbf{A}^{\intercal}$. The transpose of a vector is a matrix with only one row.

$$
(\textbf{A}^\intercal)_{\textit{i,j}} = \textit{A}_{\textit{j,i}}
$$

The tranpose is essentially the swapping of the rows and columns:
$$
\textbf{A} = \begin{bmatrix}
x_{1,1} x_{1,2} x_{1,3} \\
x_{2,1} x_{2,2} x_{2,3}
\end{bmatrix}
\text{ transposed to }
\textbf{A}^{\intercal} = \begin{bmatrix}
x_{1,1} x_{2,1} \\
x_{1,2} x_{2,2} \\
x_{1,3} x_{2,3}
\end{bmatrix}
$$

Matrices can be added together so long as they have the same shape. Add two matrices by adding their corresponding elements:
$$
\textit{C}_{\textit{i,j}} = \textit{A}_{\textit{i,j}} + \textit{B}_{\textit{i,j}}
$$

Add or multiply a matrix by a scalar by performing the operation on each element of the matrix with the scalar:
$$
\textbf{D} = \textit{a} * \textbf{B} + \textit{c}
$$

Broadcasting