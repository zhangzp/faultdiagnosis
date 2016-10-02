function [ layer ] = definelayer( tagn,timen)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
in=timen*tagn;
out=round(47*(((tagn-5)/45+4)*((timen-1)/19+9)-36)/14)+3;
ls=round(log(in/out)/log(2)+0.1)+1;
layer = cell(ls-1,9);
%
for i=1:size(layer,1)
    %
    layer{i,1}=round(out*(in/out)^((ls-i)/(ls-1)));
    %
    layer{i,2}=round(out*(in/out)^((ls-i-1)/(ls-1)));
    %
end
end

