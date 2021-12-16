function [IRs] = llado2022_extactIRs(sofaFileName,lat_angles,fs)
%llado2022_extractIRs - extract impulse response signals for the given
%lateral angles from a sofa file
%
%   Input parameters:
%     sofaFileName   : hrir set in sofa format
%     lat_angles     : vector of lateral angles to extract
%     fs             : samplef frequency
%   Output parameters:
%     IRs            : Impulse response according to the following matrix
%                    dimensions: direction x time x channel/ear
%
SOFAobj=SOFAload(convertStringsToChars(sofaFileName));
if (fs ~= SOFAobj.Data.SamplingRate)
    disp('Sample Frequency mismatch');
end

for lat_id = 1:length(lat_angles)
    lat = lat_angles(lat_id);
    idx=find(round(SOFAobj.SourcePosition(:,1),0)==lat & SOFAobj.SourcePosition(:,2)==0,1);
    IRs(lat_id,:,:)=squeeze(SOFAobj.Data.IR(idx,:,:));
end
IRs = permute(IRs,[1,3,2]);
end
    