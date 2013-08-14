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
    
    function [r_des, still_falling] = getNextStep(obj,r_ic,r_a,is_right_foot)
      if is_right_foot
        if (r_ic(1) > r_a(1)) && (r_ic(1) < r_a(1) + obj.r.w) && (abs(r_ic(2) - r_a(2)) < obj.r.w)
          r_des = (r_ic - r_a(1:2)) / norm(r_ic - r_a(1:2)) * obj.r.w + r_a(1:2);
          still_falling = false;
        else
          r_des = r_ic + [obj.r.w/2; 0] * 1/exp(obj.r.dt * obj.r.omega_0);
          r_des = max([r_des, [r_a(1); r_a(2) - obj.r.w]], [], 2);
          r_des = min([r_des, [r_a(1) + obj.r.w; r_a(2) + obj.r.w]], [], 2);
          still_falling = true;
        end
      else
        if (r_ic(1) < r_a(1)) && (r_ic(1) > r_a(1) - obj.r.w) && (abs(r_ic(2) - r_a(2)) < obj.r.w)
          r_des = (r_ic - r_a(1:2)) / norm(r_ic - r_a(1:2)) * obj.r.w + r_a(1:2);
          still_falling = false;
        else
          r_des = r_ic - [obj.r.w/2; 0] * 1/exp(obj.r.dt * obj.r.omega_0);
          r_des = max([r_des, [r_a(1) - obj.r.w; r_a(2) - obj.r.w]], [], 2);
          r_des = min([r_des, [r_a(1); r_a(2) + obj.r.w]], [], 2);
          still_falling = true;
        end
      end
    end
      
    function steps = planRecovery(obj,t,u)
      persistent stored_steps
      if isempty(stored_steps)
        r_ic = obj.r.getICPoint(u);
        r_a = u(1:2);
        is_right_foot = false;
        falling = true;
        stored_steps = [];

        while size(stored_steps, 2) < 10
          r_ic = (r_ic - r_a) * exp(obj.r.dt * obj.r.omega_0) + r_a;
          [next_step, falling] = getNextStep(obj, r_ic, r_a, is_right_foot);
          is_right_foot = ~is_right_foot;
          r_a = next_step;
          stored_steps(:,end+1) = next_step;
        end
      end
      steps = stored_steps;
    end
      

    function x = update(obj,t,x,u)
      persistent status is_falling
      if isempty(status)
        status = 0;
      end
      if isempty(is_falling)
        is_falling = true;
      end
      
      r_icn = obj.r.getNextICPoint(u);
      r_ic = obj.r.getICPoint(u);
      
      if is_falling
        if floor(t / obj.r.dt) > status
          r_des = getNextStep(obj, r_ic, u(1:2), mod(status, 2));
          x = r_des;
          status = floor(t / obj.r.dt);
        end
      else
        x = (r_ic - u(1:2)) / norm(r_ic - u(1:2)) * obj.r.w + u(1:2);
      end

%       u;
%       x;
%       r_ic = obj.r.getICPoint(u);
%       g = 0.5 - norm(r_ic(1:2) - u(3:4));
%       if g <= 0
%         x = 0.5 * (u(3:4) + r_ic);
%         % x = r_ic;
%       end
    end
  end
end





