function [] = llado2022_plotEstimation(y_est_dir,y_est_uncertainty,angle_id,y_test)

%   Input parameters:
%     y_est_dir          : Estimated data for perceived direction
%     y_est_uncertainty  : Estimated data for perceived uncertainty
%     angle_id           : Vector of lateral angles of the test subset
%
%   Optional input parameters:
%     'y_test'           : labels from subjective test


%%  DEFAULT OPTIONAL INPUTS
%%
figure;
if nargin > 3
    plot(angle_id,y_test(:,1),'k','LineWidth',2);
    hold on;
end
plot(angle_id,y_est_dir,'k','LineStyle','--','LineWidth',2);
title("Perceived direction");
ylim([min(angle_id)-10 max(angle_id)+10])
xlim([min(angle_id)-10 max(angle_id)+10])
ax = gca();
grid(ax, 'on') 
set(ax,'XTick',angle_id)
ylabel('Perceived direction (°)')
xlabel('Sound source direction (°)')

ax.XTick = [angle_id];
ax.XTickLabel = [angle_id];


ax.YTick = [angle_id];
ax.YTickLabel = [angle_id(end:-1:1)];
set(gca, 'YDir','reverse')
if nargin > 3
    legend('Subjective','NN-Estimated','Location','northwest');
else
    legend('NN-Estimated','Location','northwest');
end



%%
figure;
if nargin >3
    plot(angle_id,y_test(:,2),'k','LineWidth',2);
    hold on;
end
plot(angle_id,y_est_uncertainty,'k','LineStyle','--','LineWidth',2);
title("Position uncertainty");
ylim([0 10])
xlim([min(angle_id)-10 max(angle_id)+10])
ax = gca();
grid(ax, 'on') 
set(ax,'XTick',angle_id)
ylabel('Position uncertainty (°)')
xlabel('Sound source direction (°)')
ax.XTick = [angle_id];
ax.XTickLabel = angle_id;

if nargin > 3
    legend('Subjective','NN-Estimated','Location','northwest');
else
    legend('NN-Estimated','Location','southwest');
end
end