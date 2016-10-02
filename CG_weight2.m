function [ verr,dw ] = CG_weight2( w,v0,vtarget )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N = size(v0,1);
ws= size(w,1);
vs=cell(ws+1,1);
vs{1,1}=v0;
for wi=1:ws
    vout=[vs{wi,1},ones(N,1)]*w{wi,1};
    if wi==ws
        vs{wi+1,1} = 1./(1+exp(0-vout));
    else
        vs{wi+1,1} = vout;
    end
end
% verr = sum(sum( (vtarget-vout{end,1}).^2 ))/N;
% derr_dvout = 2*(vout{size(vout,1),1}-vtarget)/N;
vnetout=vs{end,1};
ln=size(vnetout,2);
verr=0;
for i=1:N
    for j=1:ln
        if vtarget(i,j)==1
            if vnetout(i,j)<=0
                verr=verr-log(1e-100);
            else
                verr=verr-log(vnetout(i,j));
            end
        else
            if vnetout(i,j)>=1
                verr=verr-log(1e-100);
            else
                verr=verr-log(1-vnetout(i,j));
            end            
        end        
    end
end
verr=verr/N;
derr_dvout = (vs{end,1}-vtarget)/N;
dw=cell(ws,1);
derr_dw=derr_dvout';
for dwi=ws:-1:1
    dw{dwi,1}=(derr_dw*[vs{dwi,1},ones(N,1)])';
    dtd=w{dwi,1}*derr_dw;
    derr_dw=dtd(1:end-1,:);
end
end