# Normal Delaunay Triangulation, from scipy
# Example courtesy of Catie Jo at https://medium.com/@catiejo/2d-delaunay-triangulation-by-hand-without-a-voronoi-diagram-513156fd549f

import numpy as np
from scipy.spatial import Delaunay
import matplotlib.pyplot as plt

points = np.array([[-500, -500], [500, -500], [-500, 500], [500,500]])
tri = Delaunay(points, incremental=True,qhull_options="QJ")

plt.ion()
fig, ax = plt.subplots()

ax.clear()
ax.triplot(points[:,0], points[:,1], tri.simplices)
plt.show()

def draw(point):
    global points
    points = np.append(points,[point],axis=0)
    tri.add_points([point],restart=False)
    ax.triplot(points[:,0], points[:,1], tri.simplices)
    plt.pause(1)
    ax.clear()
    ax.triplot(points[:,0], points[:,1], tri.simplices)
    plt.show()

def locate(point):
    loc = tri.find_simplex(point)
    ax.plot(point[0],point[1],'o')
    plt.show()
    print(tri.simplices)
    loc_tri = tri.simplices[loc]
    print(loc_tri)
    ax.triplot(points[:,0], points[:,1], [loc_tri])
    plt.show()