function [lin_mat_bus, sim_data_bus, traj_bus, traj_hat_bus, lin_withd_bus] = getBusTypes(nx, nu)

    elems(1) = Simulink.BusElement;
    elems(1).Name = 'F'; elems(1).Dimensions = [nx, nx];
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'G'; elems(2).Dimensions = [nx, nu];
    lin_mat_bus = Simulink.Bus;
    lin_mat_bus.Elements = elems;
    
    elems(1) = Simulink.BusElement;
    elems(1).Name = 'P'; elems(1).Dimensions = [nx, nx];
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'G'; elems(2).Dimensions = [nx, nu];
    sim_data_bus = Simulink.Bus;
    sim_data_bus.Elements = elems;
    
    elems(1) = Simulink.BusElement;
    elems(1).Name = 'x'; elems(1).Dimensions = [nx, 1];
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'u'; elems(2).Dimensions = [nu, 1];
    traj_bus = Simulink.Bus;
    traj_bus.Elements = elems;
    
    elems(1) = Simulink.BusElement;
    elems(1).Name = 'x_hat'; elems(1).Dimensions = [nx, 1];
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'u'; elems(2).Dimensions = [nu, 1];
    traj_hat_bus = Simulink.Bus;
    traj_hat_bus.Elements = elems;
    
    elems(1) = Simulink.BusElement;
    elems(1).Name = 'F'; elems(1).Dimensions = [nx, nx];
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'G'; elems(2).Dimensions = [nx, nu];
    elems(3) = Simulink.BusElement;
    elems(3).Name = 'd'; elems(3).Dimensions = [nx, 1];
    lin_withd_bus = Simulink.Bus;
    lin_withd_bus.Elements = elems;
    
end

