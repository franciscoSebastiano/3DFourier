function geom = createGeom(filename, res)
    disp('creating geometry');

    TR = stlread(filename);
    vertices = TR.Points;
    faces = TR.ConnectivityList;

    x = linspace(min(vertices(:,1)), max(vertices(:,1)), res);
    y = linspace(min(vertices(:,2)), max(vertices(:,2)), res);
    z = linspace(min(vertices(:,3)), max(vertices(:,3)), res);
    
    [X, Y, Z] = meshgrid(x, y, z);
    points = [X(:), Y(:), Z(:)];
    
    logic_array2 = reshape(intriangulation(vertices, faces, points), size(X));
    logic_array2 = permute(logic_array2, [2, 1, 3]);

    geom = logic_array2;
end
