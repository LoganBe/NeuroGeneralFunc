function [p, xs, jits] = CoolerBox(Data,cl,var,lw)
%COOLERBOX      Creates a BETTER box plot that puts scatter on the box
%
%               [p,xs,jits] = CoolerBox(Data,cl,var,lw) creates a boxplot
%               of Data with data scattered on it with some jitter. This
%               can make paralell box plots as to compare multiple data
%               sets. 
%
% Input:
%   Data - Cells of data with sizes [mxn]. Each cell must have same number
%          of columns but any number of rows.
%   cl - Colors [nx3]. Each row should have its own color 
%   var - variance for the scattered data points; default is 0.05
%   lw - line width for the box plot; defualt is 2
% 
% Output:
%   p - Scatter info. This can be used to set legend and change the
%       colors/features of the scattered data
%   xs - X axis marker locations
%   jits - Scatter Jitter locations


if nargin < 3
    var = 0.05; %Default variance in jitter
end

if nargin < 4
    lw = 1; %default linewidth
end

if nargin < 2 || isempty(cl)
    cl = 'k'; %default color
    cl = repmat(cl,length(Data),1);
end

if length(cl) > length(Data)
    cl = cl(1:length(Data));
end

datatemp = Data{1}; %Take in Data
%Make vector for placements of each of the boxes
startvals = 0.5:1:1000; endvals = 3*size(datatemp,2):1:length(startvals);
startvals = startvals(1:size(Data,2)); endvals = endvals(1:size(Data,2));
totvals = [startvals;endvals];
xs = []; jits = [];

%Get xtick info
if length(Data) == 1
    xticks = 1:1:size(datatemp,2);
else
    xticks = size(Data,2)/2:size(Data,2)+1:3*size(datatemp,2);
end
p = cell(1,length(Data));

%Go through each of the data sets 
for i = 1:size(Data,2)
    datatemp = Data{i};

    if length(Data) == 1
        x = 1:1:size(datatemp,2);
    else
        if size(datatemp,2) > 3
            x = linspace(totvals(1,i), totvals(2,i), size(datatemp,2));
        else
            x = totvals(1,i):size(Data,2)+1:totvals(2,i);
        end
    end
    
    if length(Data{i}) == 1
        x = 0.5;
    end
    
    jit1 = var*randn(size(datatemp)); %jitter for scatter 
    if size(datatemp,2) ~= length(x)
        error('Size mismatch -- Look into') 
    end
    h = boxplot(datatemp,'positions',x,'width',0.5,'color',cl(i,:)); %make the box plot
    set(h,{'linew'},{lw})
    hold on

    p{i} = plot(jit1+x,datatemp,'o','color',cl(i,:),'HandleVisibility','off'); %Scatter the data
    
    xs = [xs;x]; %save plot info
    jits = [jits;jit1];
end

