classdef LIPPlant < HybridDrakeSystem
  properties
    g = 1.0
    zc = 1.0
  end

  methods
    function obj = LIPPlant()
      obj = obj@HybridDrakeSystem(...
        0, ...  % number of inputs
        6);     % number of outputs

      sys = LIPSwingPlant(obj.zc, obj.g);
      obj = setOutputFrame(obj,sys.getOutputFrame);
      [obj,swing_mode] = addMode(obj,sys);  % add the single mode

      obj = addTransition(obj, ...
        swing_mode, ...           % from mode
        @guardICx, ...
        @stepDynamics, ...
        false, ...
        true);
    end

    function gx = guardICx(obj,t,x,u)
      r_ic = obj.getICPoint(x);
      gx = 0.5 - abs(r_ic(1) - x(1));
    end

    function [xn, m, status] = stepDynamics(obj,m,t,x,u)
      r_ic = obj.getICPoint(x);
      xn = [x(1:2); 0.5*(x(1:2) + r_ic); x(5:6)];
      status = 0;
    end

    function v = constructVisualizer(obj)
      v = LIPVisualizer(obj);
    end

    function r_ic = getICPoint(obj, x)
      omega_0 = sqrt(obj.g/obj.zc);
      r_ic = [x(1); x(2)] + omega_0 * obj.zc * [x(5); x(6)];
    end

    % function y = output(obj,t,x,u)
    %   y = x(2:7);
    % end
  end
end