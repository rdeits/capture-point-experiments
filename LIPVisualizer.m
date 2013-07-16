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
      plot3([x(1), x(3)], [x(2), x(4)], [obj.plant.zc, 0], 'ro');
      axis image;
      axis([-1, 1, -1, 1, -0.5, 1.5]);
    end
  end
end