function x_dot = model2(params, x,u)
    lr = params.b;
    lf = params.a;
    psi = x(3);
    delta = u(1);
    v = u(2);
    
    beta = atan((lr*tan(delta)/(lr+lf)));
    x_dot = [v * cos(psi + beta);
             v * sin(psi + beta);
             (v*cos(beta))/(lf + lr) *tan(delta);
             ];
end

