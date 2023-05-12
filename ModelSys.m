classdef ModelSys < matlab.System & matlab.system.mixin.Propagates
    % Untitled3 Add summary here
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.
    properties(Nontunable)
        model_params
    end
    % Public, tunable properties
    properties

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

        function x_dot = stepImpl(obj, x, u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            x_dot = obj.model_params.dynamics(obj.model_params.params, x, u);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end

        function x_dot = getOutputSizeImpl(obj)
            % Return size for each output port
            x_dot = [obj.model_params.nx 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function x_dot = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            x_dot = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function x_dot = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            x_dot = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function x_dot = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            x_dot = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end
    end
end
