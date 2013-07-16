classdef LIPSwingPlant < LinearSystem
  properties
    zc
  end

  methods
    function obj = LIPSwingPlant()
      g = 9.8;
      zc = 1.0;
      Ac = [0 0 0 0 1 0;
            0 0 0 0 0 1;
            0 0 0 0 0 0;
            0 0 0 0 0 0;
            g/zc 0 -g/zc 0 0 0;
            0 g/zc 0 -g/zc 0 0];
      Bc = zeros(6,1);
      obj = obj@LinearSystem(Ac, Bc, [], [], eye(6), []);
      obj = setOutputFrame(obj, obj.getStateFrame());
      obj.zc = zc;
    end

    function obj = constructVisualizer(plant)
      obj = LIPVisualizer(plant);
    end
  end
end

