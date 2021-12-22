function [points , index] = find_simplex(point, TRI)
    index = pointLocation(TRI,point);
    points = TRI.Points(TRI.ConnectivityList(index,:),:);
end