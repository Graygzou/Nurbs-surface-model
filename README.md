# Nurbs-surface-model
Representing curves and surfaces with [Non-Uniform Rational B-Spline](https://en.wikipedia.org/wiki/Non-uniform_rational_B-spline) (NURBS) model. This project was made during an interpolation course, followed at [ENSEEIHT](http://www.enseeiht.fr/fr/index.html), a french engineer school.

All scripts are written in Matlab and comments are in french.

# Table of Content
* Splines uniformes en produit tensoriel
* NURBS

## Splines uniformes en produit tensoriel

The source code of this part is located in the `Splines` folder. Basically, It creates tensor-product surfaces. We used the subdivision algorithm on closed B-Spline curves. Tensor-product surfaces has the torus topology, which is presented in the following example.

### Results

<img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Cone/tore.png" width="31%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Cone/tore1.png" width="34%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Cone/tore2.png" width="34%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Cone/tore3.png" width="34%">

## NURBS

The source code of this part is located in the `Nurbs curves` folder which allows to draw curves. The `Nurbs surfaces` folder can generate the following 3D results.

### Results

<img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig5.png" width="31%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig5-etape1.png" width="34%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig5-etape2.png" width="34%">

<img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig2.png" width="31%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig2-etape1.png" width="34%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig2-etape2.png" width="34%">

<img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig9.png" width="31%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig9-etape1.png" width="34%"><img src="https://github.com/Graygzou/Nurbs-surface-model/blob/master/Images/Surfaces/fig9-etape2.png" width="34%">

# Contributors
* [Grégoire Boiron](https://github.com/Graygzou)
* [Matthieu Le Boucher](https://github.com/Meight)
