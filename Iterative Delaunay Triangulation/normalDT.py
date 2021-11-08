# Normal Delaunay Triangulation, from scipy
# Example courtesy of Catie Jo at https://medium.com/@catiejo/2d-delaunay-triangulation-by-hand-without-a-voronoi-diagram-513156fd549f

import numpy as np
from scipy.spatial import Delaunay
import matplotlib.pyplot as plt

points = np.array([[-0, -0], [1, 0], [1, -1], [5,1]])



tri = Delaunay(points, incremental=True,qhull_options="QJ")
plt.triplot(points[:,0], points[:,1], tri.simplices)
plt.plot(points[:,0], points[:,1], 'o')
plt.show()

points = np.append(points,[[5,5]],axis=0)
tri.add_points(np.array([[5,5]]),restart=False)
print(points)
print(tri.simplices)
plt.triplot(points[:,0], points[:,1], tri.simplices)
plt.plot(points[:,0], points[:,1], 'o')
plt.show()