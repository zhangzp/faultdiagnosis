function [ verr,dw ] = CG_weight1( w,v0,vtarget )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N = size(v0,1);
vout=cell(size(w,1)+1,1);
vout{1,1}=v0;
for wi=1:size(w)
    vout{wi+1,1} =[vout{wi,1},ones(N,1)]*w{wi,1};
end
verr = sum(sum((vtarget-vout{end,1}).^2 ))/N;
dw=cell(size(w,1),1);
derr_dvout = 2*(vout{end,1}-vtarget)/N/1;
derTdw=derr_dvout';
for dwi=size(dw,1):-1:1
    dw{dwi,1}=(derTdw*[vout{dwi,1},ones(N,1)])';
    dtd=w{dwi,1}*derTdw;
    derTdw=dtd(1:end-1,1:N);
end
end

