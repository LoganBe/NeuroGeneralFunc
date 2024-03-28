function [ISI, logISI, meanISI, varISI] = Calc_ISI(spike_info, nT, data_type, t, varargin)

% Calc_ISI = Calculates ISI and log ISI
%   ISI = Cacl_ISI(spike_info, spike_type, t, Plot) is the spike interspike
%   interval given a set of spike times. 
%
%   input: 
%       spike_info - vector of spike data (either in Spike Times or binned
%       spike counts)
%       nT - Number of trials (default set to 1)
%       data_type - string type of data ('spiketimes','binary')
%       t - vector of times corresponding to the spike trial (Only needed 
%       if spike_info is in binned spikes countes)
%       Plot - Indicator to plot the ISI and logISI (set to False by
%       default)
%
%   output:
%       ISI - Calculated interspike intervals
%       logISI - Calculated log Interspike intervals
%       meanISI - mean ISI distribution
%       varISI - varaicne of ISI distribution
%

if nargin < 2; nT = 1; end %Set number of trials
if nargin < 3 || isempty(data_type); data_type = 'spiketimes'; end %Set the spike info type


%Make sure data is in right format
if size(spike_info,1) ~= nT 
    spike_info = spike_info';
end

assert(size(spike_info,1) == nT, 'Number of Trials does not match data')

if strcmp(data_type, 'binned')
    st = zeros(size(spike_info));
    for i = 1:nT
        st(i,spike_info(i,:) > 0) = t(spike_info(i,:) > 0);
    end
elseif strcmp(data_type, 'spiketimes')
    st = spike_info;
else
    error('Wrong Data Type')
end

ISI = [];
for nt_ = 1:nT
    st_ = nonzeros(st(nt_,:));
    ISI = [ISI; diff(st_)];
end
logISI = log(ISI);

meanISI = mean(ISI);
varISI = var(ISI);
Plot = ~isempty(varargin);
if Plot
    figure()
    subplot(2,1,1)
    histogram(ISI)
    xlabel('Time'); ylabel('Counts')
    title('Interspike interval histgoram')
    set(gca,'fontsize',16)

    subplot(2,1,2)
    histogram(logISI)
    xlabel('Time'); ylabel('Counts')
    title('Log Interspike interval histgoram')
    set(gca,'fontsize',16)
end



   
