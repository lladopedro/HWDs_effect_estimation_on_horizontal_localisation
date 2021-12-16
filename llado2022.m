function [y_est] = llado2022(ir,stim,fs,NN_pretrained)
%LLADO2022 Binaural perceptual similarity
%
%   Input parameters:
%     'ir'       : Impulse response according to the following matrix
%                dimensions: direction x time x channel/ear
%
%   Output parameters:
%     'y_est'    : Estimated values for perceived direction and position
%                uncertainty.
%
%   Optional input parameters:
%     'stim'             :stimulus. If empty, 250 ms of pink noise
%     'fs'               :(DEFAULT = 48000)
%     'NN_pretrained'    :if empty, a pretrained NN is used. To see details
%                        or to train a new NN, please see the script
%                        'demo_llado2022'
%
%   LLADO2022(...) is a model for estimating the effect of head-worn
%   devices on frontal horizontal localisation. A neural network (NN) was
%   trained using binaural features of a dummy head wearing different
%   head-worn devices to predict the data from a perceptual test using the
%   same devices. If you want to use your own data, please find in the
%   script 'demo_llado2022' the whole procedure.
%
%
%   Authors:
%   Pedro Lladó, Petteri Hyvärinen, Ville Pulkki.
%   Correspondence to pedro.llado@aalto.fi

    %%  DEFAULT OPTIONAL INPUTS
    if nargin<4; load('NN_pretrained.mat'); end % Find an example on how to train the network in 'demo_llado2022'
    if nargin<3; fs=48000; end
    if nargin<2; stim = pinknoise(0.25*fs); end
    
    %% EXTRACT BINAURAL FEATURES
    binauralFeatures = llado2022_binauralFeats(ir,stim,fs);
    
    %% EVALUATE PRETRAINED NETWORK
    y_est = llado2022_evaluateNN(binauralFeatures,NN_pretrained);
end