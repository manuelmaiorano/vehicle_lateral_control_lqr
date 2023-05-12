classdef Observer < matlab.System & matlab.system.mixin.Propagates
    % Untitled Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        weights_obs
        model_params
        H_tr
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)

    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

function [x_hat_dot, Pe_dot] = stepImpl(obj,x_hat, Pe, y, u, lin_params)
    F = lin_params.F;
    G = lin_params.G;

    Qe = obj.weights_obs.Qe;
    Reinv = obj.weights_obs.Reinv;
    H = obj.H_tr';

    Ke = Pe * H * Reinv;
    y_hat = obj.H_tr * x_hat;
    x_dot_nom = obj.model_params.dynamics(obj.model_params.params, x_hat, u);%F * x_hat + G * u

    x_hat_dot = x_dot_nom + Ke * (y - y_hat);
    Pe_dot = Pe*F' +F*Pe- Pe * H * Reinv * obj.H_tr * Pe +Qe;
end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        function [x_hat_dot, Pe_dot] = getOutputSizeImpl(obj)
            % Return size for each output port
            x_hat_dot = [obj.model_params.nx 1];
            Pe_dot = [obj.model_params.nx obj.model_params.nx];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function [out,out2] = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            out = "double";
            out2 = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function [out,out2] = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            out = false;
            out2 = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function [out,out2] = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            out = true;
            out2 = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end
    end
end
