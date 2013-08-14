classdef LIPVisualizer < Visualizer
  properties
    plant
    controller
  end

  methods
    function obj = LIPVisualizer(r)
      obj = obj@Visualizer(r.getOutputFrame());
      obj.plant = r;
    end
    
    function draw(obj, t, x)
      persistent hFig

      if isempty(hFig)
        hFig = sfigure(105);
        set(hFig, 'DoubleBuffer', 'on');
      end

      sfigure(hFig);
      hold off
      plot3([x(1), x(3)], [x(2), x(4)], [0, obj.plant.zc], 'ro-');
%       plot([x(1), x(3)], [0, obj.plant.zc], 'ro-');
      hold on
      r_ic = obj.plant.getICPoint(x);
%       plot3([r_ic(1)], [r_ic(2)], 0, 'g*')
%       r_a1f = obj.plant.getRa1f(x);
%       r_a2f = obj.plant.getRa2f(x);
      r_icn = obj.plant.getNextICPoint(x);
%       plot3([r_a1f(1)], [r_a1f(2)], 0, 'r*')
%       plot3([r_a2f(1)], [r_a2f(2)], 0, 'b*')
%       plot(r_a2f(1), 0, 'b*')
%       plot(r_ic(1), 0, 'g*');
%       plot(r_icn(1), 0, 'b*');
      plot3(r_ic(1), r_ic(2), 0, 'g*');
      plot3(r_icn(1), r_icn(2), 0, 'b*');
      
      steps = obj.controller.planRecovery(t, x);
      plot3(steps(1,:), steps(2,:), zeros(1, size(steps, 2)), 'ko');
      axis image;
      axis([-3, 3, -2, 2, -0.5, 1.5]);
%       xlim([-10, 10]);
    end
  end
end
