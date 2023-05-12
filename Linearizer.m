classdef Linearizer < matlab.System & matlab.system.mixin.Propagates
    % Untitled5 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties(Nontunable)
        model_params
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

        function [F, G] = stepImpl(obj,traj)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            [F, G, d] = obj.linearize(traj.x, traj.u);
        end
        function [F, G, d] = linearize(obj, x_segn, u_segn)
            F = obj.model_params.linearizer.F(x_segn, u_segn);
            G = obj.model_params.linearizer.G(x_segn, u_segn);
            d = obj.model_params.dynamics(obj.model_params.params, x_segn, u_segn);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        function [F, G] = getOutputSizeImpl(obj)
            % Return size for each output port
            F = [obj.model_params.nx obj.model_params.nx];
            G = [obj.model_params.nx obj.model_params.nu];

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
