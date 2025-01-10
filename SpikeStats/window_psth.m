function [fbined,steps] = window_psth(bined_data, nT, stepsize, len, smoothed, meanflag)

%Window_psth    Creates a binned psth of a bined_data set given by a window 
%               size of pbin and a time step size of stepsize. 
%
%               [fbined, steps] = window_psth(bined_data, nT, stepsize, len, smoothed). 
%               Utilizies a moving window of size pbin, by interval of stepsize. 
%               Takes mean counts within given window. No Overlap. 
%               Final psth may then smoothed via convoling a gaussian kernal. 
%
% Input:
%    bined_data = [nxm] binned spike data.
%    nT = number of trials, n
%    stepsize = window size to decrease dimmensions for bined_data 
%    len = final smoothing window size
%    smoothed = boolean indicator if to smooth the psth, default = true
%
% Output:
%    fbined = binned psth
%    steps = time bins associated with fbined
%*******************************

if nargin < 5; smoothed = false; end
if nargin < 6; meanflag = 1; end

%Size check
if nT ~= size(bined_data,1)
    bined_data = bined_data';
end
assert(size(bined_data,1) == nT, 'nT is incorrect, does not match size of data');

steps= 1:stepsize:size(bined_data,2); % steps of size stepsize
fbined = zeros(nT,length(steps)); 

%Create PSTH
c=1;
for i = steps
    if i+stepsize>(size(bined_data,2))
        fbined(:,c:end) = [];
        break
    else
        if meanflag
            fbined(:,c)= mean(bined_data(:,i:i+stepsize),2); %average count in pbin window during given time
        elseif varflag
            fbined(:,c) = var(bined_data(:,i:i+stepsize),2);
        else                
            fbined(:,c)= sum(bined_data(:,i:i+stepsize),2); %average count in pbin window during given time
        end
    end
    c=c+1;
end

fbined = fbined;%/stepsize; %Fix to Hz
if nargin < 4
    lent = length(steps); 
    len = floor(lent*0.1);
end
% Gaussian Kernal
if smoothed
    b = (len-1)/8;
    len= [1 len];
    smoothfilt = fspecial('gaussian', len, b+1);
    psth_filt = smoothfilt/norm(smoothfilt,1); 

    %Smooth
    fbined = nanconv(fbined,psth_filt,'same'); 

    %Fix edge effect
    datatemp = ones(1,size(fbined,2));
    so = conv(datatemp,psth_filt,'same');

    fbined = fbined./so;
    if nT > 1
        fbined = nanmean(fbined,1);
    end
else
    if nT > 1
        fbined = nanmean(fbined);
    end
end
steps(end) = [];
