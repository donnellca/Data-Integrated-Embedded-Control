# Normal Delaunay Triangulation, from scipy
# Example courtesy of Catie Jo at https://medium.com/@catiejo/2d-delaunay-triangulation-by-hand-without-a-voronoi-diagram-513156fd549f

import numpy as np
from scipy.spatial import Delaunay
import matplotlib.pyplot as plt
import matplotlib.animation as anime

points = np.array([[-500, -500], [500, -500], [-500, 500], [500,500]])
added_points = np.array([[-150, -100],[150, 100],[150, -150],[-150, 150],[0, 300],[300, 100],[0, 50],[100, -20],[-100, -350],[-200, 50]])
tri = Delaunay(points, incremental=True,qhull_options="QJ")

fig, ax = plt.subplots()

def init_drawing():
    ax.clear()
    ax.triplot(points[:,0], points[:,1], tri.simplices)
    plt.pause(1)

def drawing(frame):
    global points
    points = np.append(points,[added_points[frame,:]],axis=0)
    tri.add_points([added_points[frame,:]],restart=False)
    ax.triplot(points[:,0], points[:,1], tri.simplices)
    plt.pause(1)
    ax.clear()
    ax.triplot(points[:,0], points[:,1], tri.simplices)

Animation = anime.FuncAnimation(fig,drawing,frames = range(0,max(added_points.shape)),init_func = init_drawing,interval=1000,repeat=False)
plt.show()