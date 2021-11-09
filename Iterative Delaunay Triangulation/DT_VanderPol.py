# Delaunay Triangulation, Van der Pol example

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
ax.triplot(points[:,0], points[:,1], tri.simplices)
plt.pause(1)

def drawing(frame):
    global points
    points = np.append(points,[T_f[frame,:]],axis=0)
    tri.add_points([T_f[frame,:]],restart=False)
    ax.clear()
    ax.triplot(points[:,0], points[:,1], tri.simplices)

Animation = FuncAnimation(fig,drawing,frames = range(200),interval=10,repeat=False)

plt.show()