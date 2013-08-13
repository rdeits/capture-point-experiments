classdef LIPVisualizer < Visualizer
  properties
    plant
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
%       plot3([x(1), x(3)], [x(2), x(4)], [0, obj.plant.zc], 'ro-');
      plot([x(1), x(3)], [0, obj.plant.zc], 'ro-');
      hold on
      r_ic = obj.plant.getICPoint(x);
%       plot3([r_ic(1)], [r_ic(2)], 0, 'g*')
      plot(r_ic(1), 0, 'g*')
      r_a1f = obj.plant.getRa1f(x);
      r_a2f = obj.plant.getRa2f(x);
%       plot3([r_a1f(1)], [r_a1f(2)], 0, 'r*')
%       plot3([r_a2f(1)], [r_a2f(2)], 0, 'b*')
      plot(r_a2f(1), 0, 'b*')
      axis image;
%       axis([-1, 1, -1, 1, -0.5, 1.5]);
      xlim([-10, 10]);
    end
  end
end