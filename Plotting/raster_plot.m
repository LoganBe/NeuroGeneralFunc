function [p] = raster_plot(spike_info,nT,dt,color_type,offset,marker_size)
% raster_plot      Creates a raster plot of the given bined data
%
%                  [] = raster_plot(bined_data, nT ,t) creates a plot
%                  showing action potenial times across trials (raster
%                  plot).
% Input:
%   spike_info - [mxn] matrix constisting of either spike times or bined spike
%   info. Time component should match with time vector t
%   nT - Number of trials - scaler equal to m
%   t - time vector of length n
%   data_type - declare the type of data used (bined or spiketimes).
%   Default is bined
%
% Output:
%   Raster plot
%

%Default spike_info is bined
if nargin == 6
    ms = marker_size; if isempty(ms); ms = 6; end
elseif nargin == 5
    ms = 6;
elseif nargin  == 4
    ms = 6; offset = 0;
elseif nargin < 4
    color_type = "k"; ms = 6; offset = 0;
end

color_type = color_type;
%Make sure spike_info matched the number of trials
if size(spike_info,1) ~= nT
    spike_info = spike_info';
end

assert(size(spike_info,1) == nT,'nT is incorrect, does not match size of data')

[st_tr, st_idx] = find(spike_info);
p = plot(st_idx*dt,st_tr+offset,'color',color_type,'Marker','.','Linestyle','none','MarkerSize',ms);
%%
%{
%Convert data to spike times if bined
if strcmp(data_type, 'bined')
    st = cell(nT,1);
    spike_info(spike_info>1) = 1;
    for i = 1:nT
        st{i} = nonzeros(spike_info(i,:).*t);
        if isempty(st{i})
            st{i} = nan;
        end
    end
else
    st = spike_info;
end
    
%Create the raster plot
%if isempty(clr); clr = 'k'; end
for i = 1:nT
    plot(st{i},i+offset,color_type); hold on
end
%}