classdef LIPSwingPlant < DrakeSystem
  properties
    omega_0
    zc
    g
    Ac
  end

  methods
    function obj = LIPSwingPlant(zc, g)
      % obj.Ac = [0 0 0 0 1 0;
      %       0 0 0 0 0 1;
      %       0 0 0 0 0 0;
      %       0 0 0 0 0 0;
      %       g/zc 0 -g/zc 0 0 0;
      %       0 g/zc 0 -g/zc 0 0];
      obj = obj@DrakeSystem(4,2,2,6,false,true);
      obj.omega_0 = sqrt(g/zc);
      obj.g = g;
      obj.zc = zc;
      obj.Ac = [0 0 0 0 1 0;
                0 0 0 0 0 1;
                -g/zc, 0, g/zc, 0, 0, 0;
                0, -g/zc, 0, g/zc, 0, 0];
      % obj = obj@LinearSystem(Ac, [], [], [], eye(6), []);
      obj = setOutputFrame(obj, obj.getStateFrame());
    end

    function v = constructVisualizer(obj)
      v = LIPVisualizer(obj);
    end

    function y = output(obj,t,x,u)
      y = x;
    end

    function xcdot = dynamics(obj,t,x,u)
      xcdot = obj.Ac * x;
    end

    function xdnext = update(obj,t,x,u)
      xdnext = u;
    end

    function ts = getSampleTime(obj)
      ts = [[0;0], [0.01;0]];
    end

    function r_ic = getICPoint(obj, x)
      r_ic = [x(3); x(4)] + 1/obj.omega_0 * [x(5); x(6)];
    end
  end
end

