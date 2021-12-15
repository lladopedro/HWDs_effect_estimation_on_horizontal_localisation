function [y_est] = llado2021_evaluateNN(x_test,NN_pretrained)

%   Input parameters:
%     x_test             : Features of the test subset
%     NN_pretrained      : Pretrained network
%     hiddenLayerSize    : Size of the hidden layer
%
%   Output parameters:
%     y_est              : Estimated data
%

for iter = 1:NN_pretrained.nIter
    net_dir = NN_pretrained.preTrained_dir(1,end,iter).net;
    net_uncertainty = NN_pretrained.preTrained_uncertainty(1,end,iter).net;

    y_hat_dir(iter,:) = net_dir(x_test);
    y_hat_uncertainty(iter,:) = net_uncertainty(x_test);

end
clear clipPos;
clipPos = find(y_hat_dir < -90);
y_hat_dir(clipPos) = -90;
clear clipPos;
clipPos = find(y_hat_dir > 90);
y_hat_dir(clipPos) = 90;

y_est(:,1) = mean(y_hat_dir);
y_est(:,2) = mean(y_hat_uncertainty);
end