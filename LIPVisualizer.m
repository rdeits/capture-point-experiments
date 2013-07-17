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
      plot3([x(1), x(3)], [x(2), x(4)], [0, obj.plant.zc], 'ro-');
      hold on
      r_ic = obj.plant.getICPoint(x);
      plot3([r_ic(1)], [r_ic(2)], 0, 'g*')
      axis image;
      axis([-1, 1, -1, 1, -0.5, 1.5]);
    end
  end
end