function animate(params,data, dataTraj)

    Rect_O_p = [params.a,  1, 1;
              -params.b, 1, 1;
              -params.b, -1, 1;
              params.a, -1, 1]';
    Frame_O_p = [0, 0, 1;
                 5, 0, 1;
                 0, 5, 1;]';
          
    offset = 25;
    step = 15;
    figure;
    for i = 1:step:size(data, 1)
        psi = data(i, 3);
        tr = [data(i, 1); data(i, 2)];
        X_W_O = affine(Rotation(psi), tr);
        Rect_W_p = X_W_O * Rect_O_p;
        Frame_W_p = X_W_O * Frame_O_p;
        plotRect(Rect_W_p);
        plotFrame(Frame_W_p);
        plotTraj(dataTraj);
        
        %axis([-offset  offset -offset offset]);
        xlim([tr(1) - offset, tr(1) + offset]);
        ylim([tr(2) - offset, tr(2) + offset]);
        %axis equal;
        hold off;
        pause(0.01);
    end
    xmax = max(dataTraj(:, 1));xmin = min(dataTraj(:, 1));
    ymax = max(dataTraj(:, 2));ymin = min(dataTraj(:, 2));
    scaling = 1.1;
    xlim([xmin, xmax]*scaling);
    if((ymax-ymin)>1.0)
        ylim([ymin, ymax]*scaling);
    else
        ylim([ymin-1.0, ymax+1.0]);
    end
    axis equal;
end


function plotRect(Rect)
    for i = 1:size(Rect, 2)
        for j = 1:size(Rect, 2)
            xs = [Rect(1, i), Rect(1, j)];
            ys = [Rect(2, i), Rect(2, j)];
            plot(xs, ys);
            hold on;
        end
    end
end

function plotFrame(Frame)
    O = Frame(:, 1);
    X = Frame(:, 2);
    Y = Frame(:, 3);
    plotLine(O(1:2), X(1:2), 'r');
    hold on;
    plotLine(O(1:2), Y(1:2), 'g');
    
end

function plotTraj(dataTraj)
    plot(dataTraj(:, 1), dataTraj(:, 2), 'r');
end

function plotLine(A, B, color)
    plot([A(1), B(1)], [A(2), B(2)], color);
end


