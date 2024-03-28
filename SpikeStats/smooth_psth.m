function [f_bined, psth_filt, so] = smooth_psth(bined_data, nT, dt, info)
% PSTH      Creates PSTH of binned spike data
%           [f_bined, psth_filt,so] = psth(binarydata,nT,dt,info,so) will
%           create a smoothed Peri-stimulus time histogram of the binary
%           with properties given by info
%
% Input:
%   binned_data - binned spiked train (binned at interval dt) [mxn]
%   nT - number of trials (Number of columns of binary data)
%   dt - bin size 
%   info - Structure with info containing smooth paramters
%           pbin = window size for the filter
%           filt_type = filter type (gauss or boxcar)
%
% Output:
%   f_bined - Smoothed PSTH
%   psth_filt - Filter used to Smooth
%   so - Correction vector for the edges
%

% Check data is in right shape
if size(bined_data,1) ~= nT
    bined_data = bined_data';
end

assert(size(bined_data,1) == nT,'nT is incorrect, does not match size of data');

% If using a sparse matrix, will change it to full
if issparse(bined_data)
    bined_data = full(bined_data);
end

%Create default filter info (10% data length with gauss filter
if nargin < 4
    lent = size(bined_data,2); 
    info.pbin = lent*0.1;
    info.filt_type = 'gauss';
end
    
%Load in info
pbin = info.pbin; filt_type = info.filt_type;
len = pbin;

%Create filter
if strcmp(filt_type,'gauss')    
    b = (len-1)/8;
    len= [1 len];
    smoothfilt = fspecial('gaussian', len, b+1);
    psth_filt = smoothfilt/norm(smoothfilt,1); 
elseif strcmp(filt_type, 'boxcar')
    psth_filt = ones(1,len);
else
    error('Wrong Filter Type')
end

%Make adjusting vector
datatemp = ones(1,size(bined_data,2));
so = conv(datatemp,psth_filt,'same');

%Take convolution
f_bined = nanconv(bined_data,psth_filt,'edge');

%Adjust
f_bined = f_bined/dt;
if nT > 1; f_bined = mean(f_bined,1); end

    


