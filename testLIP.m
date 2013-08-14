function testLIP()
close all;
% r = LIPPlant;
g = 9.8;
zc = 1.0;
r = LIPSwingPlant(zc, g);
c = CapturePointController(r);
c = setInputFrame(c, r.getOutputFrame());
c = setOutputFrame(c, r.getInputFrame());
sys = feedback(r, c);
% sys = r;

omega_0 = sqrt(g/zc);
ts = [0, 5];
xtraj = sys.simulate(ts, [0;0;0;0;-0.5;0;0;2]);
% xtraj = sys.simulate(ts, [0;0;0.1;0;0;0]);
xval = xtraj.eval(linspace(ts(1),ts(end)));
% sfigure(1); plot(linspace(ts(1),ts(end)), [xval; xval(3,:) + omega_0 * xval(5,:)]);
% legend('rx', 'ry', 'r_ankx', 'r_anky', 'rdx', 'rdy', 'r_icx');
v = r.constructVisualizer();
v.controller = c;
% v.playbackAVI(xtraj, 'latest.avi');
v.playback(xtraj, struct('slider', 1));
end
