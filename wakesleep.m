function [ weight,wserr] = wakesleep( weight,vdata,showfig)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

maxepoch=50+1;
wserr=zeros(maxepoch,2);
[s1,s2]=size(vdata);
trs=round(0.9*s1);
if trs==s1
    trs=s1-1;
end
traindata=vdata(1:trs,:);
testdata=vdata((trs+1):s1,:);
batchsize=1200;
batchdata=zeros(batchsize,s2,trs/batchsize);
for batch=1:(trs/batchsize)
    batchdata(:,:,batch)=traindata(((batch-1)*batchsize+1):(batch*batchsize),:);
end

if showfig
    close all;
    fig = figure('Position',[700,400,1000,600]);
end
for epoch = 1:maxepoch
    wserr(epoch,1)=0;
    vrout = traindata;
    for wi=1:size(weight)
        vout_1= [vrout,ones(trs,1)];
        vrout = vout_1*weight{wi,1};
    end
    wserr(epoch,1)= wserr(epoch,1)+sum(sum( (traindata-vrout).^2 ))/trs/s2;
    wserr(epoch,2)=0;
    veout=testdata;
    for wi=1:size(weight)
        vout_1=[veout,ones(s1-trs,1)];
        veout = vout_1*weight{wi,1};
    end
    wserr(epoch,2) = wserr(epoch,2)+sum(sum( (testdata-veout).^2 ))/(s1-trs)/s2;
    if showfig
        subplot(2,3,1),plot(traindata');
        subplot(2,3,2),plot(vrout');
        subplot(2,3,3),plot(wserr(1:epoch,1));
        subplot(2,3,4),plot(testdata');
        subplot(2,3,5),plot(veout');
        subplot(2,3,6),plot(wserr(1:epoch,2));
        getframe(fig);
    end
    fprintf(1,'Epoch %d Train: %6.6f Test: %6.6f\n',epoch-1,wserr(epoch,1),wserr(epoch,2));
    if epoch~=maxepoch
        wakew=weight(1:size(weight)/2,1);
        sleepw=weight((size(weight)/2+1):size(weight),1);
        for batch=1:size(batchdata,3)
            max_iter=1;
            vout=batchdata(:,:,batch);
            for wi=1:size(wakew)
                vout_1=[vout,ones(size(vout,1),1)];
                vout = vout_1*wakew{wi,1};
            end
            [ sleepw,~] = updateweight( sleepw,max_iter,vout,batchdata(:,:,batch),1);
            redata=vout;
            for wi=1:size(sleepw)
                vout_1=[redata,ones(size(redata,1),1)];
                redata = vout_1*sleepw{wi,1};
            end
            [ wakew,~] = updateweight( wakew,max_iter,redata,vout,1);
        end
        weight(1:size(weight)/2,1)=wakew;
        weight((size(weight)/2+1):size(weight),1)=sleepw;
    end
        %     save('weaksleepweight.mat','weight','err','-mat');
end
% close all;
% plot(err(:,1),'r'),hold on;plot(err(:,2),'b'),hold off;legend('Train error','Test error');
end

