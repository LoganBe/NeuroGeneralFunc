function [fbined,steps] = window_var(bined_data, nT, stepsize)

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
        fbined(:,c)= var(bined_data(:,i:i+stepsize),[],2); %average count in pbin window during given time
    end
    c=c+1;
end