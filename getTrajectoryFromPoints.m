function [traj, T] = getTrajectoryFromPoints(roadcenters, waypoints, speed, t_step, nx, nu)
    scenario = drivingScenario('SampleTime', t_step);
    lspec = lanespec(2);
    road(scenario,roadcenters,'Lanes',lspec);
    v = vehicle(scenario,'ClassID',1);
    trajectory(v,waypoints, speed)
    plot(scenario,'Waypoints','on','RoadCenters','on')
    x = zeros([500, 6]);
    t = zeros([500, 1]);
    i = 1;
    x(i, :) = getPose(scenario);
    t(i) = scenario.SimulationTime;
    while advance(scenario)
        i = i +1;
        x(i, :) = getPose(scenario);
        t(i) = scenario.SimulationTime;
    end
    x1 = x(1:i, :);
    t1 = t(1:i);
    x1 = x1';
    x1 = x1(1:nx, :);
    states = reshape(x1, [nx, 1, size(x1, 2)]);
    traj.x = timeseries(states, t1);
    u = zeros([nu, 1, size(x1, 2)]);
    traj.u = timeseries(u, t1);
    T = size(x1, 2)*t_step;
end

function pose = getPose(scenario)
        pose = zeros([6,1]);
        pose(1:2) = scenario.actorPoses.Position(1:2);
        pose(3) = scenario.actorPoses.Yaw * pi/180;
        velocityGlobalFrame = scenario.actorPoses.Velocity(1:2);
        pose(4:5) = Rotation(pose(3))' *velocityGlobalFrame';
        pose(6) = scenario.actorPoses.AngularVelocity(3)* pi/180;
end

