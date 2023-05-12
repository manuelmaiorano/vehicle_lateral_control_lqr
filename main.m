clc
clear all
close all

weights.Q = diag([1500,1500,0]);% x y psi
weights.R = diag([50,10]);% delta v
weights.Rinv = inv(weights.R);


weights_obs.Qe = diag(ones([6, 1]))*0.5;
weights_obs.Reinv = inv(diag(ones([4, 1]))*0.05);

params = getParams();

model = @model2;
nx = 3; nu = 2; ny = 2;

weights.Q = weights.Q(1:nx, 1:nx);
weights.R = weights.R(1:nu, 1:nu);
weights.Rinv = inv(weights.R);

weights_obs.Qe = weights_obs.Qe(1:nx, 1:nx);
weights_obs.Reinv = weights_obs.Reinv(1:ny, 1:ny);
Pe0 = zeros([nx nx]);

H_tr = eye(nx);
H_tr =  H_tr(1:2,:);

model_params.dynamics = model;
model_params.nx = nx; model_params.nu = nu;
model_params.params = params;
model_params.linearizer = getLinearizer(model_params.dynamics, nx, nu, params);

roadcentersCirc = ...
    [  0  40  49  50 100  50  49 40 -40 
     -50 -50 -50 -50   0  50  50 50  50 
       0   0 .45 .45 .45 .45 .45  0   0]'*3;
roadcentersLin = ...
    [  0  200 
     -50 -50
       0   0 ]';
vels = [17, 22, 27, 36];
for i=1:numel(vels)
    linear_simulations(i).roadcenters = roadcentersLin;
    linear_simulations(i).name = "lineare" + num2str(vels(i));
    linear_simulations(i).vx = vels(i);
    linear_simulations(i).var = [0, 0];
    linear_simulations(i).dis_amp = 0.1;
end


simulation_circ.roadcenters = roadcentersCirc;
simulation_circ.name = 'circuito';
simulation_circ.vx = 15;
simulation_circ.var = [0, 0];
simulation_circ.dis_amp = 0;

simulation_dis.roadcenters = roadcentersCirc;
simulation_dis.name = 'circuito con rumore';
simulation_dis.vx = 17;
simulation_dis.var = [0.05, 0.05];
simulation_dis.dis_amp = 0;


t_step = 0.01; vref = 25;

%start sim
[lin_mat_bus, sim_data_bus, traj_bus, traj_hat_bus, lin_withd_bus] = getBusTypes(nx, nu);

if 1
    %simulate(simulation_lin, 'lin');
    fileID = fopen('log_rumore.txt','w');
    [out, results] = simulate(simulation_circ, 'circ');
    fprintf(fileID, num2str(results.error_max)+ "," + num2str(results.vely_max));
end
if 0
    fileID = fopen('log_rumore.txt','w');
    [out, results] = simulate(simulation_dis, 'dis');
    fprintf(fileID, sqrt(simulation_dis.var(1)) +","+num2str(results.error_max)+ "," + num2str(results.vely_max));
end
if 0
    fileID = fopen('log.txt','w');
    log = "vx, error_max,vy_max,settling_t,delta_max\n ";
    data_ = DataStore(numel(linear_simulations));
    for i=1:numel(linear_simulations)
        [out, results] = simulate(linear_simulations(i), linear_simulations(i).name);
        data_.add(out, i);
        log = append(log, num2str(linear_simulations(i).vx) + ",");
        log = append(log, num2str(results.error_max)+ ",");
        log = append(log, num2str(results.vely_max)+ ",");
        log = append(log, num2str(results.settling_t)+ ",");
        log = append(log, num2str(results.delta_max)+ "\n");
    end
    fprintf(fileID, log);
    data_.plot();
end

function [out, results] = simulate(simulation, dir_name)
    vref = simulation.vx;
    t_step = 0.01; nx=3; nu=2;
    disp('interpolated trajectory...');
    disp(simulation.name);
    [traj_simple, T] = getTrajectoryFromPoints(simulation.roadcenters, simulation.roadcenters, simulation.vx, t_step, nx, nu);

    u0 = [0; simulation.vx];
    x0_nom = traj_simple.x.data(1:nx,1,1);
    
    assignin('base','u0',u0)
    assignin('base','x0_nom',x0_nom)
    assignin('base','T',T)
    assignin('base','traj_simple',traj_simple)
    assignin('base','variance',simulation.var)
    assignin('base','dis_amp',simulation.dis_amp)
    
    disp('controlling...');
    out = sim('control_sim');
    stati = get(out,'stati');
    controlli = get(out,'controlli');
    traj_actual = get(out,'traj_actual');
    
    assignin("base","stati",stati);
    assignin("base","controlli",controlli);
    assignin("base","traj_actual",traj_actual);



    mkdir("./plots/" + dir_name);
    
    results = makeplots(dir_name);
    

end

%animate(params, squeeze(controlled_out_second.data)', squeeze(traj_simple.x.data)');