function testLIP()
r = LIPSwingPlant;
xtraj = r.simulate([0, 4], [0.1;0;0;0;0;0]);
v = r.constructVisualizer();
v.playback(xtraj, struct('slider', 1));
end
