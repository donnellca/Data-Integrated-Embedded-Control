# Delaunay Triangulation, for use on REPL
# Implements draw(point) to add points and locate(point) to find the simplex containing a point

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
    loc_tri = tri.simplices[loc]
    ax.triplot(points[:,0], points[:,1], [loc_tri])
    plt.show()