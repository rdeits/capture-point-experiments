classdef LIPSwingPlant < DrakeSystem
  properties
    omega_0
    zc
    g
    Ac
    w = 1
    dt = 0.25
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
      Ex = 1/2 * (x(5)/obj.omega_0)^2 - 1/2*(x(3) - x(1))^2;
      Ef = -obj.w^2/8;
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
    
    function r_icn = getNextICPoint(obj, x)
      r_ic = getICPoint(obj, x);
      r_icn = (r_ic - [x(1); x(2)]) * exp(obj.dt * obj.omega_0) + [x(1);x(2)];
    end

    function r_a1f = getRa1f(obj, x)
      r_a1f = [x(3) + sqrt((x(5)/obj.omega_0)^2 - obj.w^2/2 * (cosh(obj.omega_0 * obj.dt)-5/2));0];
    end

    function r_a2f = getRa2f(obj, x)
      if x(5) > 0
        r_a2f = [x(3) + sqrt((x(5)/obj.omega_0)^2 + (obj.w/2)^2);0];
      else
        r_a2f = [x(3) - sqrt((x(5)/obj.omega_0)^2 + (obj.w/2)^2);0];
      end
    end

  end
end

