classdef LIPSwingPlant < LinearSystem
  methods
    function obj = LIPSwingPlant(zc, g)
      Ac = [0 0 0 0 1 0;
            0 0 0 0 0 1;
            0 0 0 0 0 0;
            0 0 0 0 0 0;
            g/zc 0 -g/zc 0 0 0;
            0 g/zc 0 -g/zc 0 0];
      Bc = zeros(6,1);
      obj = obj@LinearSystem(Ac, [], [], [], eye(6), []);
      obj = setOutputFrame(obj, obj.getStateFrame());
    end
  end
end

