function [ classifier,classerr] = classifytrain(maxepoch,classifier,traindata,trainlabel,testdata,testlabel,faulti,nori,isall,showfig)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
maxepoch=maxepoch+1;
classerr=zeros(maxepoch,8);

[cn,dn,bn]=size(traindata);
ldn=1;%size(trainlabel,2);
bns=12;
if isall
    ntraind=zeros(bns*cn,dn,bn/bns);
    ntrainl=zeros(bns*cn,ldn,bn/bns);
    for batch = 1:(bn/bns)
        for kk=1:bns
            ntraind(((kk-1)*cn+1):(kk*cn),:,batch)=traindata(:,:,(batch-1)*bns+kk);
            ntrainl(((kk-1)*cn+1):(kk*cn),:,batch)=trainlabel(:,faulti,(batch-1)*bns+kk);
        end
    end
else
    ntraind=zeros(bns*cn,dn,bn/bns);
    ntrainl=zeros(bns*cn,ldn,bn/bns);
    nci=1;
    nbi=1;
    for bi = 1:bn
        for ci=1:cn
            if trainlabel(ci,faulti,bi) || trainlabel(ci,nori,bi)
                ntraind(nci,:,nbi)=traindata(ci,:,bi);
                ntrainl(nci,:,nbi)=trainlabel(ci,faulti,bi);
                nci=nci+1;
                if nci>bns*cn
                    nci=1;
                    nbi=nbi+1;
                end
            end
        end
    end
    if nci==1
        nbi=nbi-1;
    end
    ntraind=ntraind(:,:,1:nbi);
    ntrainl=ntrainl(:,:,1:nbi);
end
[s1,s2,s3]=size(ntrainl)
pause;
trainlabel = trainlabel(:,faulti,:);
testlabel = testlabel(:,faulti,:);
if showfig
    close all;
    fig = figure('Position',[700,400,1000,600]);
end
cs = size(classifier,1);
for epoch = 1:maxepoch
    [cn,ln,bn]=size(trainlabel);
    suml=0;
    for batch = 1:bn
        v0 = traindata(:,:,batch);
        for wi=1:cs
            v0 = [v0,ones(cn,1)]*classifier{wi,1};
            if wi==cs
                v0 = 1./(1+exp(0-v0));
            end
        end
        l0 = trainlabel(:,:,batch);
        suml=suml+sum(l0==1);
        c0=0+(v0>0.5);
        classerr(epoch,1) = classerr(epoch,1)+sum(sum( (l0-v0).^2 ))/ln;
        classerr(epoch,3) = classerr(epoch,3)+sum((l0-c0)==0);
        classerr(epoch,5) = classerr(epoch,5)+sum((l0-c0)==1);
        classerr(epoch,7) = classerr(epoch,7)+sum((l0-c0)==-1);
    end    
    classerr(epoch,1) = classerr(epoch,1)/cn/bn;
    classerr(epoch,3) = classerr(epoch,3)/cn/bn;
    classerr(epoch,5) = classerr(epoch,5)/suml;
    classerr(epoch,7) = classerr(epoch,7)/(cn*bn-suml);
    [cn,ln,bn]=size(testlabel);
    suml=0;
    for batch = 1:bn
        v1 = testdata(:,:,batch);
        for wi=1:cs
            v1 = [v1,ones(cn,1)]*classifier{wi,1};
            if wi==cs
                v1 = 1./(1+exp(0-v1));
            end
        end
        l1 = testlabel(:,:,batch);
        suml=suml+sum(l1==1);
        c1=0+(v1>0.5);
        classerr(epoch,2) = classerr(epoch,2)+sum(sum((l1-v1).^2))/ln;
        classerr(epoch,4) = classerr(epoch,4)+sum((l1-c1)==0);
        classerr(epoch,6) = classerr(epoch,6)+sum((l1-c1)==1);
        classerr(epoch,8) = classerr(epoch,8)+sum((l1-c1)==-1);
    end
    classerr(epoch,2) = classerr(epoch,2)/cn/bn;
    classerr(epoch,4) = classerr(epoch,4)/cn/bn;
    classerr(epoch,6) = classerr(epoch,6)/suml;
    classerr(epoch,8) = classerr(epoch,8)/(cn*bn-suml);
    if showfig
        subplot(2,2,1),plot(l0,'bo'),hold on;plot(v0,'r+'),hold off;axis([0 cn+1 -0.1 1.1])
        subplot(2,2,2),plot(classerr(2:epoch,1),'r'),hold on;plot(classerr(2:epoch,2),'b'),hold off;legend('Train error','Test error');
        subplot(2,2,3),plot(l1,'bo'),hold on;plot(v1,'r+'),hold off;axis([0 cn+1 -0.1 1.1])
        subplot(2,2,4),plot(classerr(2:epoch,5),'r'),hold on;
        plot(classerr(2:epoch,6),'b'),hold on;
        plot(classerr(2:epoch,7),'g'),hold on;
        plot(classerr(2:epoch,8),'y'),hold off;legend('Train Miss','Test Miss','Train Error','Test Error');
        getframe(fig);
    end
    fprintf(1,'Epoch %d Error: %6.6f-%6.6f Miss: %6.6f-%6.6f Error: %6.6f-%6.6f \n',epoch-1,classerr(epoch,1),classerr(epoch,2),classerr(epoch,5),classerr(epoch,6),classerr(epoch,7),classerr(epoch,8));
    if epoch~=maxepoch
        [~,~,bn]=size(ntraind);
        for batch = 1:bn
            v0=ntraind(:,:,batch);
            l0=ntrainl(:,:,batch);
            max_iter=[-3,0.1];
            [ classifier,~] = updateweight( classifier,max_iter,v0,l0,2);
        end
    end
%     save('classifier.mat','classifier','test_err','train_err','-mat');
end
end

