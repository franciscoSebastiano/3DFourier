% note: generating massive logical arrays from stl file using createGeom
% takes a long time. Take this into account and save the arrays you will
% re-use often.
res = 100; % size of nxnxn grid

wire_temperature = 1300; % 1300 kelvin
air_temp = 293; % kelvin room temp

insulation_conductivity = 0.25; % ceramic fiber (w/mk)
glass_conductivity = 1.3; % quartz tube
nichrome_conductivity = 13; % nichrome wire
air_conductivity = 0.03; % very rough estimate or air conduction

insul_geom = createGeom('insul.stl', res); % create matrix of insulation values
insul_geom = insul_geom * insulation_conductivity;

wire_geom = createGeom('wire.stl', res); % create matrix of nichrome wire values
nichrome_geom = wire_geom * nichrome_conductivity;

tube_geom = createGeom('tube.stl', res); % create matrix of glass tube values
tube_geom = tube_geom * glass_conductivity;

geom_p = tube_geom + insul_geom + nichrome_geom; % combine all conductivity geometries into one array
geom = geom_p;
geom(geom_p == 0) = air_conductivity;

temp_geom = wire_geom * wire_temperature; % create matric of temperatures
temp_geom(wire_geom == 0) = air_temp;

T = runSim(geom, temp_geom, wire_temperature, air_temp);
%figure;
plotStl('full_cyl.stl', T, 0.5);
figure;
hold on
scatterPlotObject(geom_p, T, 1, 0);

axis equal;
colorbar;
%caxis([0,500]);
title('Tube Furnace Fourier Model (steady state)');
xlabel('x');
ylabel('y');
zlabel('z');
pause(0.1);
view(30,30)

insul_geom = logical(insul_geom);
energy = sum(T .* insul_geom, "all");

