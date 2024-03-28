function [fanofactor, tvec] = binned_FF(ws, t, y,len)

if nargin < 4; len = 0; end
    
tvec = 1:ws:length(t);
fanofactor = zeros(1,length(tvec)-1);

for i = 2:length(tvec)
    sc = sum(y(tvec(i-1):tvec(i),:));
    fanofactor(1,i-1) = mean((sc-mean(sc)).^2)/mean(sc);
end
tvec(end) = [];

if len > 0
    b = (len-1)/8;
    len= [1 len];
    smoothfilt = fspecial('gaussian', len, b+1);
    psth_filt = smoothfilt/norm(smoothfilt,1); 

    %Make adjusting vector
    datatemp = ones(1,size(fanofactor,2));
    so = conv(datatemp,psth_filt,'same');

    %Take convolution
    fanofactor = nanconv(fanofactor,psth_filt,'edge');
end

%Smooth
