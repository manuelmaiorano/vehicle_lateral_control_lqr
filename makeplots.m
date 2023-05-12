function results =  makeplots(dir_name)
    t_step = evalin('base', 't_step');
    stati = evalin('base','stati');
    controlli = evalin('base','controlli');
    traj_actual = evalin('base','traj_actual');
    
    line_width = 1.5;
    max_t = max(stati.Time(:,1));
    dir = "plots\" + dir_name + "\";
    f0 = figure;
    plot(controlli.Time(:,1), squeeze(traj_actual.x.Data(1, :)), 'b');
    hold on;
    plot(controlli.Time(:,1), squeeze(traj_actual.x.Data(2, :)), 'b');
    hold on;
    plot(stati.Time(:,1), squeeze(stati.Data(1, :)), 'r');
    hold on;
    plot(stati.Time(:,1), squeeze(stati.Data(2, :)), 'r');
    legend('pos x nominale[m]', 'pos y nominale[m]', 'pos x controllata[m]', 'pos y controllata[m]');
    hold off;
    general_config(line_width, max_t, 'Confronto posizioni');
    saveas(f0, dir + dir_name + '_' +'confronto.png');

    f = figure;
    subplot(2,1,1);
    plot(stati.Time(:,1), squeeze(stati.Data(5, :)));
    legend('vel y[m/s]');
    general_config(line_width, max_t, 'Velocità laterale');
    subplot(2,1,2);
    plot(controlli.Time(:,1), squeeze(controlli.Data(1, :)));
    legend('sterzata[rad]');
    hold off;
    general_config(line_width, max_t, 'Angolo di sterzata');
    saveas(f, dir +  dir_name + '_' +'vely_sterzata.png');

    f1 = figure;
    xy_ = squeeze(stati.Data(1:2, :));
    trj_xy = squeeze(traj_actual.x.data(1:2, 1, :));
    dist = sqrt(sum((xy_-trj_xy).^2, 1));
    plot(stati.Time(:,1), dist(1,:));
    legend('errore[m]');
    hold off;
    general_config(line_width, max_t, 'Errore');
    saveas(f1, dir +  dir_name + '_' +'errore.png');

    f2 = figure;
    plot(stati.Time(:,1), squeeze(stati.Data(4, :)));
    legend('vel x[m/s]');
    hold off;
    general_config(line_width, max_t, 'Velocità longitudinale');
    saveas(f2, dir +  dir_name + '_' +'velx.png');

    f3 = figure;
    subplot(2, 1, 1);
    plot(stati.Time(:,1), squeeze(stati.Data(1, :)));
    hold on;
    plot(stati.Time(:,1), squeeze(stati.Data(2, :)));
    legend('posx[m]', 'posy[m]');
    general_config(line_width, max_t, 'Posizione del veicolo');
    hold off;
    subplot(2, 1, 2);
    plot(stati.Time(:,1), squeeze(stati.Data(3, :)));
    legend('yaw[rad]');
    general_config(line_width, max_t, 'Orientamento del veicolo');
    saveas(f3, dir +  dir_name + '_' +'yaw_pos.png');
   
    
    idx = find(dist>0.001); 
    vely = squeeze(stati.Data(5, :));
    results.vely_max = max(abs((vely<0).*vely));
    results.settling_t = (idx(end)-idx(1))* t_step;
    results.delta_max = max(abs(squeeze(controlli.Data(1, :))));
    results.error_max = max(dist);
    
    function general_config(line_width, max_t, title)
        set(gcf, 'Position', get(0, 'Screensize'));
        grid on;
        ax = gca;
        ax.XLim = [0 max_t];
        ax.FontSize = 12;
        ax.Title.String = title;
        ax.XLabel.String = 'tempo[s]';
        %ax.YLabel.String = labely;
        lines = get(ax, 'Children');
        for i= 1:size(lines, 1)
            lines(i).LineWidth = line_width;
        end
    end
end


