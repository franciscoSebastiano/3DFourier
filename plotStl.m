function plotStl(filename, T, alpha_value)
    disp('plotting stl');

    res = size(T);
    res = res(1);
    TR = stlread(filename);
    scale_factor = res / 200; 
    boat = TR;
    shift = [scale_factor * 100, scale_factor * 100 + 2, 0];
    
    rotation_angle_x = 0;
    rotation_angle_y = 0;  
    rotation_angle_z = 0;  
    
    vertices = boat.Points;
    faces = boat.ConnectivityList;
    vertices = vertices * scale_factor + shift;
    
    rotation_matrix_x = [1, 0, 0; 0, cos(rotation_angle_x), -sin(rotation_angle_x); 0, sin(rotation_angle_x), cos(rotation_angle_x)];
    rotation_matrix_y = [cos(rotation_angle_y), 0, sin(rotation_angle_y); 0, 1, 0; -sin(rotation_angle_y), 0, cos(rotation_angle_y)];
    rotation_matrix_z = [cos(rotation_angle_z), -sin(rotation_angle_z), 0; sin(rotation_angle_z), cos(rotation_angle_z), 0; 0, 0, 1];
    
    center = mean(vertices, 1);
    
    vertices = vertices - center;
    
    vertices = (rotation_matrix_x * vertices')';
    vertices = (rotation_matrix_y * vertices')';
    vertices = (rotation_matrix_z * vertices')';
    
    vertices = vertices + center;

    [xDim, yDim, zDim] = size(T);
    [xGrid, yGrid, zGrid] = meshgrid(linspace(min(vertices(:,1)), max(vertices(:,1)), yDim), ...
                                     linspace(min(vertices(:,2)), max(vertices(:,2)), xDim), ...
                                     linspace(min(vertices(:,3)), max(vertices(:,3)), zDim));
    % Interpolate data values at STL vertices
    faceCentroids = (vertices(faces(:,1), :) + vertices(faces(:,2), :) + vertices(faces(:,3), :)) / 3;

    % Interpolate data values at the face centroids
    valuesOnFaces = interp3(xGrid, yGrid, zGrid, T, faceCentroids(:,2), faceCentroids(:,1), faceCentroids(:,3));
    
    % Plot the STL surface with interpolated values as colors
    stl = patch('Vertices', vertices, 'Faces', faces, ...
      'FaceVertexCData', valuesOnFaces, ...
      'FaceColor', 'flat', ...
      'EdgeColor', 'none');
    alpha(stl, alpha_value);

end