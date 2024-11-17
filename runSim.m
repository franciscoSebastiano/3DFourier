function T = runSim(k_geom, T_geom, geom_temp, boundary_T)
    % grid points
    disp('running simulation');
    
    NX = length(k_geom);
    
    K1 = k_geom;

    T = T_geom;
    Tnew = T;
    
    % plotting stuff
    count = 0;
    while (count < 1000)
    for i = 2:NX-1
        for j = 2:NX-1
            for k = 2:NX-1
                % calculate y and z terms from heat equation
                Tnew(i,j,k) = (1/(3*K1(i,j,k) + K1(i-1,j,k) + K1(i,j-1,k) + K1(i,j,k-1))) * ...
                              ((K1(i,j,k) * (T(i+1,j,k) + T(i,j+1,k) + T(i,j,k+1))) + ...
                               K1(i-1,j,k)*T(i-1,j,k) + K1(i,j-1,k)*T(i,j-1,k) + K1(i,j,k-1)*T(i,j,k-1));
            end
        end
    end
    T = Tnew;
    T(T_geom == 1) = geom_temp;
    count = count + 1;
    
    % boundarys
    T(:,:,end) = boundary_T;
    T(:,:,1)  = boundary_T;
    T(:,end,:)  = boundary_T;
    T(:,:,end)  = boundary_T;
    T(end,:,:)  = boundary_T;
    T(1,:,:)  = boundary_T;
    
    end

end
