function [ free ] = freeenergy(vdata,weight,vbiases,hbiases,vstd,hstd)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
vone=ones(size(vdata,1),1);
vdata = vdata./(vone*vstd);
vbiases = vbiases./vstd;
hbiases = hbiases./hstd;
free=sum(sum((vone*vbiases-vdata).^2))/2;
free=free+sum(sum((vone*hbiases).^2))/2;
free=free-sum(sum((vone*hbiases+vdata*weight).^2));
free=free-sum(sum(log(2*pi)/2+log(vone*hstd)));
end

