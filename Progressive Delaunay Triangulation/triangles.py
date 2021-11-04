# Progressive Delaunay Triangulation
# Class definitions for points and triangles

class triangle():
    def __init__(self):
        self.points = [None,None,None]
    
    def __repr__(self):
        return "t" + str(self.points)
    
    def __getitem__(self, key):
        return self.points[key]
    
    def __setitem__(self, key, newvalue):
        if isinstance(key,int):
            if (key >= 0) and (key <=2):
                if isinstance(newvalue,point):
                    self.points[key] = newvalue
                    newvalue.addtriangle(self)
                    return
                else:
                    raise TypeError
            else:
                raise IndexError
        if isinstance(key,slice):
            if (key.start >= 0) and (key.stop <=3):
                if all(isinstance(x, point) for x in newvalue):
                    self.points[key] = newvalue
                    for x in newvalue:
                        x.addtriangle(self)
                    return
                else:
                    raise TypeError
            else:
                raise IndexError

class point():
    def __init__(self,x,y):
        self.coordinates = (x,y)
        self.triangle = []
    
    def __getitem__(self, key):
        return self.coordinates[key]
    
    def __repr__(self):
        return "p" + str(self.coordinates)
    
    def addtriangle(self,triangle):
        self.triangle.append(triangle)
    
    def listtriangle(self):
        return self.triangle


t1 = triangle(); t2 = triangle()
p1 = point(0,0); p2 = point(1,0); p3 = point(1,1)
t1[0:3] = [p1,p2,p3]
t2[0:3] = [p1,p2,point(2,5)]