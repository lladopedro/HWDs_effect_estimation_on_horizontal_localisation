function [net,tr] = llado2022_trainNN(x,y,hiddenLayerSize,augmentation_ratio,SNR)
    
%   Input parameters:
%     x                  : Features of the train subset
%     y                  : Labels for training the network
%     hiddenLayerSize    : Size of the hidden layer
%     augmentation_ratio : Ratio for data augmentation stage
%     SNR                : SNR of the augmented data
%
%   Output parameters:
%     net                : trained network
%     tr                 : training history
%
clear net;
net = fitnet(hiddenLayerSize);

net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 30/100;
net.divideParam.testRatio = 0/100;

%% Training data augmentation

Y_output_aug = y;
for aug_iter = 1:augmentation_ratio
    for id_col = 1:length(y(1,:))
        aux= y(:,id_col);
        Y_output_aug((aug_iter)*length(y(:,1))+1:(1+aug_iter)*length(y(:,1)),id_col) = aux;
    end
end

clear X_input_aug;
X_input_aug(:,:) = x(:,:);
for aug_iter = 1:augmentation_ratio
    for id_col = 1:length(x(1,:))
        aux= awgn(x(:,id_col),SNR,'measured');
        X_input_aug((aug_iter)*length(x(:,1))+1:(1+aug_iter)*length(x(:,1)),id_col) = aux;
    end
end

[net, tr] = train(net,X_input_aug',Y_output_aug');

end

