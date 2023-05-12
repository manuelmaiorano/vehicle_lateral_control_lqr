classdef simplecontroller < matlab.System  & matlab.system.mixin.Propagates %& matlab.system.mixin.Nondirect
    % Untitled2 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    properties(Nontunable)
        weights
        model_params
        H_tr
        threshold
        x0
        u0
    end

    % Public, tunable properties
    properties
        
    end

    properties(DiscreteState)
        current_F
        current_G
        current_d
        current_P
        current_b
        xlin
        current_u
        L
    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function [u, closest] = stepImpl(obj,x, traj)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            Rinv = obj.weights.Rinv;
            Q = obj.weights.Q;
            dist = 0.7;
            if norm(x(1:2) - traj.x(1:2) ) > dist

                disp(["distanza: "+num2str(norm(x(1:2) - traj.x(1:2)))]);
                disp('warning');
                
            end


            if norm(x(1:2) - obj.xlin(1:2) ) > obj.threshold 
                obj.xlin = x;
                [F, G, d] = obj.linearize(obj.xlin,obj.u0);
                obj.updateState(F, G, d);
            end
            F = obj.current_F;
            G = obj.current_G;
            d = obj.current_d;
            P = obj.current_P;
            y_tilde = traj.x(1:2);
            y_segn = obj.xlin(1:2);
            obj.current_b = inv(F' - P * G *Rinv*G') * (Q*obj.L*(y_tilde -y_segn)-P*(G*(-obj.u0)-d));
            P = obj.current_P;
            G = obj.current_G;
            b = obj.current_b;
            Rinv = obj.weights.Rinv;
            u = - obj.u0 - Rinv * G' * P *( x-obj.xlin)- Rinv * G' * b;
            closest = obj.xlin;
        end

        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.xlin = obj.x0;
            [F, G, d] = obj.linearize(obj.xlin,obj.u0);
            obj.updateState(F, G, d);
            H = obj.H_tr';
            obj.L = H * inv(H' * H);
            obj.current_b = zeros([numel(obj.x0), 1]);
%             P = obj.current_P;
%             d1 = d-F*obj.xlin-G*obj.u0;
%             Rinv = obj.weights.Rinv;
%             Q = obj.weights.Q;
%             obj.current_b = inv(F' - P * G *Rinv*G') * (Q*obj.x0-P*G*obj.u0- P*d1);
            
             
        end

        function [u,closest] = getOutputSizeImpl(obj)
            % Return size for each output port
            u = [numel(obj.u0) 1];
            closest = [numel(obj.x0) 1];
            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [u,closest] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            u = "double";
            closest = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [u,closest] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            u = false;
            closest = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [u,closest] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            u = true;
            closest = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end

        function [sz,dt,cp] = getDiscreteStateSpecificationImpl(obj,name)
            % Return size, data type, and complexity of discrete-state
            % specified in name
            sz = [1 1];
            if strcmp(name, 'current_F') || strcmp(name, 'current_P')
                sz = [numel(obj.x0) numel(obj.x0)];
            end
            if strcmp(name, 'current_d') || strcmp(name, 'current_b') || strcmp(name, 'xlin')
                sz = [numel(obj.x0) 1];
            end
            if strcmp(name, 'L')
                sz = [numel(obj.x0) size(obj.H_tr, 1)];
            end
            if strcmp(name, 'current_G')
                sz = [numel(obj.x0) numel(obj.u0)];
            end
            if strcmp(name, 'current_u')
                sz = [numel(obj.u0) 1];
            end
            dt = "double";
            cp = false;
        end

        function updateState(obj, F, G, d)
            obj.current_F = F;
            obj.current_G = G;
            obj.current_d = d;
            R = obj.weights.R;
            Q = obj.weights.Q;
            P = icare(F, G, Q, R);
            %[~,P,~] = lqr(F, G, Q, R);
            obj.current_P = P;
        end

        function [F, G, d] = linearize(obj, x_segn, u_segn)
            F = obj.model_params.linearizer.F(x_segn, u_segn);
            G = obj.model_params.linearizer.G(x_segn, u_segn);
            d = obj.model_params.dynamics(obj.model_params.params, x_segn, u_segn);
        end

        
    end
end
