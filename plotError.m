function plotError(controlled_out,traj, titletxt)
    figure;hold on;
    states = squeeze(controlled_out.data);
    plot(controlled_out.time, states(1, :), 'r');
    plot(controlled_out.time, states(2, :), 'r');

    pos = squeeze(traj.x.data);
    plot(traj.x.time, pos(1, :), 'b');
    plot(traj.x.time, pos(2, :), 'b');
    title(titletxt);
    
    legend('controllatedX', 'controllatedY', 'nominaleX', 'nominaleY');
    hold off;
end

