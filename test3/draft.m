%% plot figure

fig = figure(1)
plot(V4(13,:))
ylim([0.96, 1.04])
saveas(fig, 'afigure.png')
close(fig)


% sum(sum(dQsave>0))
% dQsum = cumsum(dQsave,1);
% fig = figure(1)
% for i = 1:2
%   plot(dQsum(:,i))
%   hold on
% end
% saveas(fig, 'afigure.png')
% close(fig)

% fig = figure()
% plot(Pd1(10000:24480, 1))
% hold on
% plot(Qd1(10000:24480, 1))
% saveas(fig, 'afigure.png')
% close(fig)
