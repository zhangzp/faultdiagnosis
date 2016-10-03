function [ layer] = pretrainRBMlayer( vdata,layer,li,showfig)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

maxepoch=50;
[cs,~]=size(vdata);

learnrate_w      = 0.000005;
learnrate_vb     = 0.000005;
learnrate_hb     = 0.000005;
weightcost  = 0.0002;   
momentum  = 0.8;


for i=1:li-1    
    hn=layer{i,2};
    v_w_h=layer{i,3};
    h_b=layer{i,5};
%     hstd=diag(v_w_h'*vdcov*v_w_h);hstd=(hstd').^0.5;
    hdata=zeros(cs,hn);
    hdata(:,:) = vdata*v_w_h+ones(cs,1)*h_b;
    vdata=hdata;%./(ones(cs,1)*hstd);
%     vdcov = cov(vdata);
end
vdcov = cov(vdata);
vn = layer{li,1};
hn = layer{li,2};
fprintf(1,'Layer %d to %d: %d-%d \n',li,li+1,vn,hn);
if showfig
    close all;
    fig = figure('Position',[300,200,1000,600]);
end
v_w_h = normrnd(0,0.1,vn,hn);
h_b  = zeros(1,hn);
v_b  = zeros(1,vn);
dw = zeros(vn,hn);
dhb = zeros(1,hn);
dvb = zeros(1,vn);
bs=100;bn=cs/bs;
trs = round(bs*0.9);
error_freee=zeros(4,maxepoch);
vstd = diag(vdcov)'.^0.5;
for epoch = 1:maxepoch
    traerr=0;
    valerr=0;
    trfree = 0;
    vafree = 0;
    for batch = 1:bn
        hdcov=v_w_h'*vdcov*v_w_h;
        hstd=diag(hdcov)'.^0.5;%hidden units standard deviation should be as hstd.
%         v1dcov=v_w_h*hdcov*v_w_h';
%         v1std=diag(v1dcov)'.^0.5;
%         h1std=diag(v_w_h'*v1dcov*v_w_h);
%         h1std=(h1std').^0.5;
%         hdata = vdata*v_w_h+ones(cs,1)*h_b;
%         hdata=hdata./(ones(cs,1)*hstd);% make hidden units value standard deviation to 1.
%         hdcov=cov(hdata);
%         v1data = hdata*v_w_h'+ones(cs,1)*v_b;        
%         h1data = v1data*v_w_h+ones(cs,1)*h_b;
%         h1data=h1data./(ones(cs,1)*h1std);
        v0 = vdata((batch*bs-bs+1):(batch*bs),:);
%         h0 = hdata((batch*bs-bs+1):(batch*bs),:);
%         v1 = v1data((batch*bs-bs+1):(batch*bs),:);
%         h1 = h1data((batch*bs-bs+1):(batch*bs),:);
        h0=v0*v_w_h+ones(bs,1)*h_b;
        v1=h0*v_w_h'+ones(bs,1)*v_b;
        h1=v1*v_w_h+ones(bs,1)*h_b;
        traerr= traerr+sum(sum( (v0(1:trs,:)-v1(1:trs,:)).^2 ))/size(v0,2)/trs/bn;
        valerr= valerr+sum(sum( (v0((trs+1):bs,:)-v1((trs+1):bs,:)).^2 ))/size(v0,2)/(bs-trs)/bn;
        trfree = trfree+freeenergy(v0(1:trs,:),v_w_h,v_b,h_b,vstd,hstd)/trs/bn;
        if bs~=trs
            vafree = vafree+freeenergy(v0((trs+1):bs,:),v_w_h,v_b,h_b,vstd,hstd)/(bs-trs)/bn;
        end
        if batch==bn% && epoch==maxepoch
            fprintf(1,'Mean std vdata:%.3f hdata:%.3f v0:%.3f h0:%.3f v1:%.3f h1:%.3f  \n',mean(vstd),mean(hstd),mean(std(v0)),mean(std(h0)),mean(std(v1)),mean(std(h1)));
            if showfig
                subplot(2,3,1),plot(v0(1:trs,:)'),hold on;plot(v0((trs+1):bs,:)','.'),hold off;
                subplot(2,3,2),plot(h0(1:trs,:)'),hold on;plot(h0((trs+1):bs,:)','.'),hold off;
                subplot(2,3,3),plot(1:(epoch-1),error_freee(1,1:(epoch-1)),'r',1:(epoch-1),error_freee(2,1:(epoch-1)),'b');legend('error-train','test');
                subplot(2,3,4),plot(v1(1:trs,:)'),hold on;plot(v1((trs+1):bs,:)','.'),hold off;
                subplot(2,3,5),plot(h1(1:trs,:)'),hold on;plot(h1((trs+1):bs,:)','.'),hold off;
                subplot(2,3,6),plot(1:(epoch-1),error_freee(3,1:(epoch-1)),'r',1:(epoch-1),error_freee(4,1:(epoch-1)),'b');legend('free-train','test');
                getframe(fig);
            end
        end
        v0=v0./(ones(bs,1)*vstd);
        v1=v1./(ones(bs,1)*vstd);        
        h0=h0./(ones(bs,1)*hstd);
        h1=h1./(ones(bs,1)*hstd);
        mdw=v0(1:trs,:)'*h0(1:trs,:)-v1(1:trs,:)'*h1(1:trs,:);
        dw = momentum*dw + learnrate_w*(mdw/trs - weightcost*v_w_h);
        dvb = momentum*dvb + learnrate_vb*(mean(v0(1:trs,:)-v1(1:trs,:),1));
        dhb = momentum*dhb + learnrate_hb*(mean(h0(1:trs,:)-h1(1:trs,:),1));
        v_w_h = v_w_h + dw;
        v_b = v_b + dvb;
        h_b = h_b + dhb;        
    end
    error_freee(1,epoch) = traerr;
    error_freee(2,epoch) = valerr;
    error_freee(3,epoch) = trfree;
    error_freee(4,epoch) = vafree;
    fprintf(1,'Epoch %d Error %6.6f  \n',epoch,traerr);
    layer{li,3} = v_w_h;
    layer{li,4} = v_b;
    layer{li,5} = h_b;
    layer{li,6} = error_freee(1,:);
    layer{li,7} = error_freee(2,:);
    layer{li,8} = error_freee(3,:);
    layer{li,9} = error_freee(4,:);
    %save('layerparam.mat','layeri', '-mat');
end
%showtrainprocess(layer,li);
end

