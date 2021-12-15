function [] = llado2021_weightsAnalysis(NN_pretrained)
%   Input parameters:
%     NN_pretrained : Pretrained network
%
% llado2021_weightsAnalysis analyses the weights learnt by the NN and plots
% them to understand the importance of the training features.

% NN weights analysis: perceived direction
clear A B T TOTAL TOTALavg
for j = 1:8
    for i = 1:10
        A(:,:) = abs(NN_pretrained.preTrained_dir(1,j,i).net.IW{1}(:,:))';
        B(:) = abs(NN_pretrained.preTrained_dir(1,j,i).net.LW{2}(:,:))';
        T(i,:) = mean((A.*B)');
    end



    TOTAL(j,:) = mean(T);
end
TOTALavg = mean(TOTAL);
TOTALavg = TOTALavg./(sum(TOTALavg));
figure(3);
plot(TOTALavg(1:18),'b');
hold on;
figure(4);
plot(TOTALavg(19:end),'b');
hold on;


% NN weights analysis: position uncertainty
clear A B T TOTAL TOTALavg

for j = 1:8
    for i = 1:10
        A(:,:) = abs(NN_pretrained.preTrained_uncertainty(1,j,i).net.IW{1}(:,:))';
        B(:) = abs(NN_pretrained.preTrained_uncertainty(1,j,i).net.LW{2}(:,:))';
        T(i,:) = mean((A.*B)');

    end

    TOTAL(j,:) = mean(T);
end


TOTALavg = mean(TOTAL);
TOTALavg = TOTALavg./(sum(TOTALavg));
figure(3);
plot(TOTALavg(1:18),'r');
ylim([0.02 0.04])
xlim([0 19])
title("ITD weights")
legend("Perceived direction estimation", "Position uncertainty estimation",'Location','Southeast')
figure(4);
plot(TOTALavg(19:end),'r');
ylim([0.02 0.04])
xlim([0 19])
title("ILD weights")
legend("Perceived direction estimation", "Position uncertainty estimation",'Location','Southeast')
end