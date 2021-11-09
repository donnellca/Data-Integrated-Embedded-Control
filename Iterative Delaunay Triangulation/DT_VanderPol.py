# Normal Delaunay Triangulation, from scipy
# Example courtesy of Catie Jo at https://medium.com/@catiejo/2d-delaunay-triangulation-by-hand-without-a-voronoi-diagram-513156fd549f

import numpy as np
from scipy.spatial import Delaunay
import scipy.io as sio
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

points = np.array([[-5, -5], [5, -5], [-5, 5], [5,5]])
T_f = np.transpose(sio.loadmat('samples_over_time.mat')['T_f'])
#sample_0 = np.transpose(sio.loadmat('samples_initial.mat')['sample_0'])
tri = Delaunay(points, incremental=True,qhull_options="QJ")

fig, ax = plt.subplots()

def init_drawing():
    ax.triplot(points[:,0], points[:,1], tri.simplices)

def drawing(frame):
    global points
    points = np.append(points,[T_f[frame,:]],axis=0)
    tri.add_points([T_f[frame,:]],restart=False)
    ax.clear()
    ax.triplot(points[:,0], points[:,1], tri.simplices)

Animation = FuncAnimation(fig,drawing,frames = range(0,max(T_f.shape),5),init_func = init_drawing,interval=10)

plt.show()