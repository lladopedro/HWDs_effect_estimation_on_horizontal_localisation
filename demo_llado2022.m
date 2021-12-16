% demo_llado2022 shows the use of the llado2022 model. The detailed
% procedure can be found in:
% P. Lladó, P. Hyvärinen, V. Pulkki: Auditory model -based estimation of
% the effect of head-worn devices on frontal horizontal localisation.
%
%   The demo has two options:
%   A) Reproduce the published plots: set 'precomputedModel = 1'.
%   The plotted figures are as follow:
%
%      Figure 1: Perceived direction estimation
%
%      Figure 2: Position uncertainty estimation
%
%      Figure 3: ITD weights learnt by the NN
%
%      Figure 4: ILD weights learnt by the NN
%
%   B) Train your own network: set 'preccomputedModel = 0'.
%   Feel free to experiment with different conditions, subjective data,
%   parameters of the NN, or even for different purposes.
%   (Let me know if you are going to try this option and I will help you to
%   make it work).
%
%
%   Authors:
%   Pedro Lladó, Petteri Hyvärinen, Ville Pulkki.
%   Correspondence to pedro.llado@aalto.fi



%% Choose option:
precomputedModel = 1;   % 0: compute ITD and ILD estimates and train model;
                        % 1: use precomputed ITD and ILD estimates and
                        %    pretrained model to reproduce published data

                        
%% Load precomputed binaural estimates
if precomputedModel == 1
    % Load pretrained model
    load('NN_pretrained.mat');
    % Load extracted binaural features itd and ild features
    x_input = [NN_pretrained.x_itd;NN_pretrained.x_ild];
    
    %% Training set: all devices but the test device
    testDevice = 'F-Gecko';
    
    % Getting the test subset
    angle_id = NN_pretrained.angle_id;
    nAngles = NN_pretrained.nAngles;
    device_id = NN_pretrained.device_id;
    nDevices = NN_pretrained.nDevices;
    y_output = NN_pretrained.y';
    testDevice_id = find(device_id == testDevice);

    testDevicePos = nAngles*(testDevice_id-1)+1:nAngles*(testDevice_id);

    x_test = x_input(:,testDevicePos);
    y_test = y_output(testDevicePos,:);
    
    %% evaluate pretrained model
    y_hat = llado2022_evaluateNN(x_test,NN_pretrained);    
    y_est_dir = y_hat(:,1);
    y_est_uncertainty = y_hat(:,2);
end


%% Run binaural auditory model to extract ITD and ILD from HRIR

if precomputedModel == 0
    % HRIR sofa folder
    mySofaFolder = 'SOFAfolder/';
    train_lateral_angles=[0,10,30,50,70,290,310,330,350];
    aux_angle = find(train_lateral_angles > 180);
    angle_id = train_lateral_angles;
    angle_id(aux_angle) = train_lateral_angles(aux_angle) - 360;
    angle_id = sort(angle_id);
    
    %Generate stimulus
    fs = 48000;
    stim = pinknoise(0.25*fs);

    % Extract IRs from sofa files
    mySofaFiles = dir(mySofaFolder+"/*.sofa");
    nDevices = length(mySofaFiles); 
    
    for file_id = 1:nDevices
        sofaFile_name = strcat(mySofaFolder, mySofaFiles(file_id).name);
        ir_sofa = llado2022_extractIRs(sofaFile_name,train_lateral_angles,fs);
        if file_id == 1
            ir = ir_sofa;
        else
            ir = [ir;ir_sofa];
        end
    end
    
    % Extract binaural features (ITD and ILD)
    [x_train] = llado2022_binauralFeats(ir,stim,fs);
%     X_binaural_feats = binauralAuditoryModel(mySofaFolder,...
%         train_lateral_angles,stim,fs,1);


    % Load subjective test data
    load('Y_listeningTest_labels.mat')
    % Col1 : device
    % Col2 : sound source lateral angle
    % Col3 : perceived lateral angle (average)
    % Col4 : position uncertainty (average)
    y_train = Y_listeningTest_labels(:,3:4);
   
    sofaFile_name_test = 'SOFAfolder_test/exampleTest.sofa';
    test_ir = llado2022_extractIRs(sofaFile_name_test,train_lateral_angles,fs);
    x_test = llado2022_binauralFeats(test_ir,stim,fs);

    % NN variables
    hiddenLayerSize_dir = 22;
    hiddenLayerSize_uncertainty = 16;
    augmentation_ratio = 10;
    SNR = 60;
    nIter = 2; % number of iterations to train,evaluate the model (results are averaged)

    for iter = 1:nIter
        %% Train NN: direction
        [net_dir,tr_dir] = llado2022_trainNN(x_train',y_train(:,1),hiddenLayerSize_dir,augmentation_ratio,SNR);

        %% Train NN: uncertainty
        [net_uncertainty,tr_uncertainty] = llado2022_trainNN(x_train',y_train(:,2),hiddenLayerSize_uncertainty,augmentation_ratio,SNR);

        %% Evaluate a new HWD
        y_est_dir(iter,:) = net_dir(x_test);
        y_est_uncertainty(iter,:) = net_uncertainty(x_test);
    end
end

if (isvector(y_est_dir) == 1 )
    y_est_dir = y_est_dir;
    y_est_uncertainty = y_est_uncertainty;
else
    y_est_dir = mean(y_est_dir);
    y_est_uncertainty = mean(y_est_uncertainty);
end

%%
if exist('y_test') == 1
    llado2022_plotEstimation(y_est_dir,y_est_uncertainty,angle_id,y_test);
else
    llado2022_plotEstimation(y_est_dir,y_est_uncertainty,angle_id);
end

%% NN weights analysis
if precomputedModel == 1
    showWeights = 1;
    if showWeights == 1      
        llado2022_weightsAnalysis(NN_pretrained);
    end
end