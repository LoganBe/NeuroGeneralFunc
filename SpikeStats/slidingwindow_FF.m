function [fanofactor, tvec] = slidingwindow_FF(sws, ws, t, y,len)

if nargin < 5; len = 0; end
    
tvec = 1:sws:length(t);
fanofactor = [];

for i = 2:length(tvec)
    if tvec(i-1)+ws <= length(t)
        sc = sum(y(tvec(i-1):tvec(i-1)+ws,:));
        fanofactor = [fanofactor,mean((sc-mean(sc)).^2)/mean(sc)];
    end
end
tvec(length(fanofactor)+1:end) = [];

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
