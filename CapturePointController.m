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

          if mod(status, 2) == 1
            if (r_ic(1) > u(1)) && (r_ic(1) < u(1) + obj.r.w) && (abs(r_ic(2) - u(2)) < obj.r.w)
              r_des = (r_ic - u(1:2)) / norm(r_ic - u(1:2)) * obj.r.w + u(1:2);
              is_falling = false;
            else
              r_des = r_ic + [obj.r.w/2; 0] * 1/exp(obj.r.dt * obj.r.omega_0);
              r_des = max([r_des, [u(1); u(2) - obj.r.w]], [], 2);
              r_des = min([r_des, [u(1) + obj.r.w; u(2) + obj.r.w]], [], 2);
            end
          else
            if (r_ic(1) < u(1)) && (r_ic(1) > u(1) - obj.r.w) && (abs(r_ic(2) - u(2)) < obj.r.w)
              r_des = (r_ic - u(1:2)) / norm(r_ic - u(1:2)) * obj.r.w + u(1:2);
              is_falling = false;
            else
              r_des = r_ic - [obj.r.w/2; 0] * 1/exp(obj.r.dt * obj.r.omega_0);
              r_des = max([r_des, [u(1) - obj.r.w; u(2) - obj.r.w]], [], 2);
              r_des = min([r_des, [u(1); u(2) + obj.r.w]], [], 2);
            end
          end
          x = r_des;
          status = floor(t / obj.r.dt);
        end
      else
        x = (r_ic - u(1:2)) / norm(r_ic - u(1:2)) * obj.r.w + u(1:2);
      end
            
%             
%         
%         
%         r_des = real(obj.r.getRa2f(u));
%         if mod(status, 2) == 0
%           r_des = min([r_des, u(3:4)], [], 2);
%         else
%           r_des = max([r_des, u(3:4)], [], 2);
%         end
%         max_step = 1;
%         if r_des(1) - u(3) > max_step
%           r_des(1) = u(3) + max_step;
%         elseif u(3) - r_des(1) > max_step
%           r_des(1) = u(3) - max_step;
%         end
%         status = floor(t / obj.r.dt);
%       else
%         r_des = x;
%       end
% 
%       
%       x = r_des;
%       
%       if t < obj.r.dt
%         r_des = [u(1:2)];
%       elseif t > obj.r.dt && t < 2*obj.r.dt && status == 0
%         status = 1;
%         r_des = real(obj.r.getRa2f(u));
%       % elseif t > 2*obj.r.dt && t < 3*obj.r.dt && status == 1
%       %   status = 2;
%       %   r_des = real(obj.r.getRa2f(u));
%       else
%         % if status
%         %   r_des = [u(3) + obj.r.w/2; u(2)];
%         % else
%         %   r_des = [u(3) - obj.r.w/2; u(2)];
%         % end
%         % status = ~status;
%         r_des = x;
%       end
%       x = r_des;

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





