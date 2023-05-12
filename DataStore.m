classdef DataStore < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        n_sim
        simulations
        
    end
    
    methods
        function obj = DataStore(n_sim)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.n_sim = n_sim;
        end
        
        function add(obj, out, i)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.simulations(i).times = out.stati.Time(:,1);
            obj.simulations(i).vely = squeeze(out.stati.Data(5, :));
            obj.simulations(i).velx = squeeze(out.stati.Data(4, :));
     
            xy_ = squeeze(out.stati.Data(1:2, :));
            trj_xy = squeeze(out.traj_actual.x.Data(1:2, 1, :));
            dist = sqrt(sum((xy_-trj_xy).^2, 1));
            obj.simulations(i).errors = dist(1,:);
            obj.simulations(i).delta = squeeze(out.controlli.Data(1, :));
            obj.simulations(i).yaw = squeeze(out.stati.Data(3, :));
        end
        
        function plot(obj)
            mkdir("./plots/sovrapposti");
            
            obj.do_single_plot("vely", "Velocità laterale [m/s]", "vely.png");
            obj.do_single_plot("velx", "Velocità longitudinale [m/s]", "velx.png");
            obj.do_single_plot("errors", "Errore [m]", "err.png");
            obj.do_single_plot("delta", "Angolo di sterzata [rad]", "delta.png");
            obj.do_single_plot("yaw", "Yaw [rad]", "yaw.png");

            
        end
        function do_single_plot(obj, data_name, y_lab, filename)
            dir = "./plots/sovrapposti/";
            figure;
            for i =1:obj.n_sim
                lg = num2str(obj.simulations(i).velx(1)) + "m/s";
                times = obj.simulations(i).times;
                data = obj.simulations(i).(data_name);
                T = times(end);
                idx = times < T/1.99+1 & times > T/1.99-0.01;
                plot(times(idx)-(T/1.99-0.01), data(idx), 'DisplayName', lg);
                hold on;
            end
            ylabel(y_lab);
            legend;
            obj.general_config();
            saveas(gcf, dir + filename);
        end
        function general_config(obj)
            set(gcf, 'Position', get(0, 'Screensize'));
            grid on;
            ax = gca;
        
            ax.FontSize = 12;
            ax.XLabel.String = 'tempo[s]';
            %ax.YLabel.String = labely;
            lines = get(ax, 'Children');
            for i= 1:size(lines, 1)
                lines(i).LineWidth = 1.5;
            end
        end
    end
end

