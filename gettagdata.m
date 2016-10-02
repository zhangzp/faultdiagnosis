function [ traind,trainl,testd,testl ] = gettagdata(faulti,tagn,timen)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
ld=load('D:\ZhangProject\data50select.mat');
trainl=ld.trainlable;
testl=ld.testlable;
selectv=ld.vselect(faulti,:);
[bs,~,bn]=size(ld.traindata);
traind = zeros(bs,tagn*timen,bn);
for bi=1:bn
    for vi=1:tagn
        ti=selectv(1,vi);
        traind(:,((vi-1)*timen+1):(vi*timen),bi)=ld.traindata(:,((ti-1)*20+1):((ti-1)*20+timen),bi);
    end
end
[bs,~,bn]=size(ld.testdata);
testd = zeros(bs,tagn*timen,bn);
for bi=1:bn
    for vi=1:tagn
        ti=selectv(1,vi);
        testd(:,((vi-1)*timen+1):(vi*timen),bi)=ld.testdata(:,((ti-1)*20+1):((ti-1)*20+timen),bi);
    end
end
end