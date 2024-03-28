function [] = pcdone(idx,tot,pc)

%Outputs the percent complete (given by pc) per iteration in a loop
% idx = input number in loop
% tot = total number of elements in loop
% pc = percent complete marker

if nargin < 3; pc = 10; end % Default 10%

pcnow = pc*ceil(idx/tot*100/pc); %Current percent complete
pcnext = pc*ceil((idx+1)/tot*100/pc); %Next percent complete

%Check conidtions
if idx == 1
    disp("Loop Start")
elseif idx >= tot
    disp("Loop Done")
elseif pcnext > pcnow
    disp(num2str(pcnow) + "% Complete")
end