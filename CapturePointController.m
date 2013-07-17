classdef CapturePointController < DrakeSystem
  properties
    r
  end

  methods
    function obj = CapturePointController(r)
      obj = obj@DrakeSystem(0,2,6,2,false,true);
      obj.r = r;
    end

    function y = output(obj,t,x,u)
      y = x;
    end

    function ts = getSampleTime(obj)
      ts = [[0;0], [0.01;0]];
    end

    function x = update(obj,t,x,u)
      u;
      x;
      r_ic = obj.r.getICPoint(u);
      g = 0.5 - norm(r_ic(1:2) - u(3:4));
      if g <= 0
        x = r_ic;
      end
    end
  end
end





