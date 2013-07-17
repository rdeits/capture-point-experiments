function testLIP()
r = LIPPlant;
g = 9.8;
zc = 1.0;
omega_0 = sqrt(g/zc);
ts = [0, 5];
xtraj = r.simulate(ts, [1;-0.9;0;-1;0;0;0.2]);
xval = xtraj.eval(linspace(ts(1),ts(end)));
figure(1)
plot(linspace(ts(1),ts(end)), [xval; xval(1,:) + omega_0 * zc * xval(5,:)]);
legend('rx', 'ry', 'r_ankx', 'r_anky', 'rdx', 'rdy', 'r_icx');
v = r.constructVisualizer();
% v.playbackAVI(xtraj, 'latest.avi');
v.playback(xtraj, struct('slider', 1));
end
