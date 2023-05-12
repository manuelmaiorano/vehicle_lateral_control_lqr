function linearizer = getLinearizer(dynamics, nx, nu, params)
    
    x = sym('x', [nx, 1]);
    u = sym('u', [nu, 1]);
    f = dynamics(params, x, u);
    
    F_func = matlabFunction(jacobian(f, x), 'Vars',{x,u});
    G_func = matlabFunction(jacobian(f, u), 'Vars',{x,u});
    
    linearizer.F = F_func;
    linearizer.G = G_func;
end

