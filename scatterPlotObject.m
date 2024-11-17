function scatterPlotObject(geom, T, obj_alpha, air_alpha)
    disp('generating scatter plot');

    logic_array2 = geom;
    [x, y, z] = ind2sub(size(logic_array2), find(logic_array2));
    [X, Y, Z] = ndgrid(1:50, 1:50, 1:50);
    inside_data = [x,y,z];
    grid_data = [X(:), Y(:), Z(:)];
    inside_idx = ismember(grid_data, inside_data, 'rows');
    grid_data = grid_data(~inside_idx, :);
    disp('generating grid');

    x_grid = grid_data(:,1);
    y_grid = grid_data(:,2);
    z_grid = grid_data(:,3);

    values = arrayfun(@(i) T(x(i), y(i), z(i)), 1:size(x, 1));
    air_values = arrayfun(@(i) T(x_grid(i), y_grid(i), z_grid(i)), 1:size(grid_data, 1));
    disp('generating object');
    obj = scatter3(x, y, z, [], values, 'filled', 'sizeData', 140);
    alpha(obj, obj_alpha);
    if (air_alpha)
        hold on;
        disp('generating air');
        air = scatter3(x_grid, y_grid, z_grid, [], air_values, 'filled');
        alpha(air, air_alpha);
    end

end