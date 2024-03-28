function output = slidingwindow(input,ws,ds, f)

if nargin < 4; f = @(x) mean(x); end

if size(input, 1) > 1
    input = input';
end

% Calculate the number of windows that will fit
nwin = floor((length(input) - ws) / ds) + 1;

% Initialize the output array
output = zeros(size(input,1), nwin);

% Perform the sliding window operation
for i = 1:nwin
    stidx = (i - 1) * ds + 1;
    eidx = stidx + ws;
    output(:,i) = f(input(:,stidx:eidx)); % Replace 'mean' with any desired operation
end

