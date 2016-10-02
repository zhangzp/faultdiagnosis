function [ classifier] = defineclassifier( weight,outlength )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
cw=size(weight,1)/2;
classifier=cell(cw+1,1);
% dclassi=cell(cw+1,1);
%
for i=1:cw
    classifier{i,1}=weight{i,1};
%     dclassi{i,1}=zeros(size(weight{i,1},1),size(weight{i,1},2));
end
classifier{cw+1,1}=[normrnd(0,0.01,size(weight{cw,1},2),outlength);0.5*ones(1,outlength)];
% dclassi{cw+1,1}=zeros(size(weight{cw,1},2)+1,1);
end

