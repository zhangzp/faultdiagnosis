% clear all;
close all;
%faults=1:20
showfig=1;
nori=21;
for faulti=14
    for timen=20%[20,16,13,10,8,6,4,3,2,1]
        for tagn=50%50:-5:5
%             load(['D:\ZhangProject\mat\matf',num2str(faulti),'\teline',num2str(timen),'-',num2str(tagn),'-',num2str(faulti),'.mat']);
%             [ traindata,trainlabel,testdata,testlabel ] = gettagdata(faulti,tagn,timen);
%             [s1,s2,s3]=size(traindata);
%             pretraindata=zeros(s1*s3,s2);
%             di=0;
%             for i=1:s1
%                 for k=1:s3
%                     if 1%trainlabel(i,faulti,k) || trainlabel(i,nori,k)
%                         di=di+1;
%                         pretraindata(di,:)=traindata(i,:,k);
%                     end
%                 end
%             end
%             pretraindata = pretraindata(1:di,:);
%             clear s1 s2 s3 di i k
%             [ layer ] = definelayer( tagn,timen );
%             for li=3:size(layer,1)
%                 [layer] = pretrainRBMlayer( pretraindata,layer,li,showfig);
%             end
%             clear li;
            [ weight ] = defineweight( layer);
            [ weight,wserr ] = wakesleep( weight,pretraindata,showfig);
%             [ classifier] = defineclassifier( weight,1);
%             [ classifier,classerr] = classifytrain( 101,classifier,traindata,trainlabel,testdata,testlabel,faulti,nori,1,showfig);
%             [miniv1,mini1]=min(classerr(:,1));[miniv2,mini2]=min(classerr(:,2));mini=min(mini1,mini2);
%             [miserrv,miserri]=max(classerr(:,4));
%             fprintf(1,'%6.6f %6d %6d %6d Right: %6.6f Miss: %6.6f Error: %6.6f\n',classerr(end,2),mini,miserri,size(classerr,1),classerr(miserri,4),classerr(miserri,6),classerr(miserri,8));
%             save(['D:\ZhangProject\mat\matf',num2str(faulti),'\teline',num2str(timen),'-',num2str(tagn),'-',num2str(faulti),'.mat'],'tagn','timen','faulti','layer','wserr','classerr','weight','classifier');
%             while (mini>(size(classerr,1)-11) || (classerr(end,1)>(classerr(end,2)-0.00005) && mini1>(size(classerr,1)-11))) && miserri>(size(classerr,1)-101) && size(classerr,1)<1800 % && miniv2>0.00001
%                 [ classifier,claerr] = classifytrain(1,classifier,traindata,trainlabel,testdata,testlabel,faulti,nori,1,showfig);
%                 classerr=[classerr;claerr(2,:)];
%                 [miniv1,mini1]=min(classerr(:,1));[miniv2,mini2]=min(classerr(:,2));mini=min(mini1,mini2);
%                 [miserrv,miserri]=max(classerr(:,4));
%                 fprintf(1,'%6.6f %6d %6d %6d Right: %6.6f Miss: %6.6f Error: %6.6f\n',classerr(end,2),mini,miserri,size(classerr,1),classerr(miserri,4),classerr(miserri,6),classerr(miserri,8));
%                 isbreak=0;%input('BREAK(0=NO/1=YES):');
%                 if isbreak
%                     break;
%                 else
%                     save(['D:\ZhangProject\mat\matf',num2str(faulti),'\teline',num2str(timen),'-',num2str(tagn),'-',num2str(faulti),'.mat'],'tagn','timen','faulti','layer','wserr','classerr','weight','classifier');
%                 end
%             end
        end
    end
end