%OCON
% clear all;
% faults=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,29];
% times=[8,10,20,16,20,2,1,20,20,13,20,20,16,20,20,20,8,16,13,2,8];
% tags=[40,20,50,25,40,5,5,25,50,20,50,25,30,30,50,50,20,15,20,35,45];
% traind=zeros(19200,21);
% trainl=zeros(19200,21);
% testd=zeros(4800,21);
% testl=zeros(4800,21);
% for fi=1:21
%     load(['D:\matlab\workspace\class\oneclass\teline',num2str(faults(fi)),'-',num2str(times(fi)),'-',num2str(tags(fi)),'.mat'],'classifier');
%     [ traindata,trainlabel,testdata,testlabel ] = gettagdata(faults(fi),tags(fi),times(fi));
%     [cn,~,bn]=size(traindata);
%     for batch = 1:bn
%         v0 = traindata(:,:,batch);
%         for wi=1:size(classifier,1)
%             v0 = [v0,ones(cn,1)]*classifier{wi,1};
%             if wi==size(classifier,1)
%                 v0 = 1./(1+exp(0-v0));
%             end
%         end
%         traind(((batch-1)*cn+1):(batch*cn),fi)=v0;
%         trainl(((batch-1)*cn+1):(batch*cn),fi)=trainlabel(:,faults(fi),batch);
%     end
%     [cn,~,bn]=size(testdata);
%     for batch = 1:bn
%         v0 = testdata(:,:,batch);
%         for wi=1:size(classifier,1)
%             v0 = [v0,ones(cn,1)]*classifier{wi,1};
%             if wi==size(classifier,1)
%                 v0 = 1./(1+exp(0-v0));
%             end
%         end
%         testd(((batch-1)*cn+1):(batch*cn),fi)=v0;
%         testl(((batch-1)*cn+1):(batch*cn),fi)=testlabel(:,faults(fi),batch);
%     end
%     clear batch bn classifier cn testdata testlabel traindata trainlabel v0 wi
% end
% clear fi faults tags times
% save OCON.mat
% load('OCON.mat');
% classifier=cell(21,1);
% classerr=cell(21,1);
% classreault=zeros(21,8);
% for fi=21 
%     cei=classerr{fi,1};
%     cfi{1,1}=classifier{fi,1};    
%     clf;plot(cei(2:end,1),'r'),hold on;plot(cei(2:end,2),'b'),hold off;legend('Train','Test');pause;
%     clf;plot(cei(2:end,3),'r'),hold on;plot(cei(2:end,4),'b'),hold off;legend('Train','Test');pause;
%     clf;plot(cei(2:end,5),'r'),hold on;plot(cei(2:end,6),'b'),hold off;legend('Train','Test');pause;
%     clf;plot(cei(2:end,7),'r'),hold on;plot(cei(2:end,8),'b'),hold off;legend('Train','Test');pause;
%     if input('RETRAINCLASS(0=NO/1=YES):')
%         cfi{1,1}=[normrnd(0,0.01,21,1);0.5*ones(1,1)];
%         [cfi,cei] = classifytrain( 2,5,cfi,traind,trainl(:,fi),testd,testl(:,fi));
%     end
%     [~,mini1]=min(cei(:,1));[miniv2,mini2]=min(cei(:,2));mini=min(mini1,mini2);
%     [miserrv,miserri]=max(cei(:,4));
%     fprintf(1,'%6.6f %6d %6d %6d Right: %6.6f Miss: %6.6f Error: %6.6f\n',cei(end,2),mini,miserri,size(cei,1),cei(miserri,4),cei(miserri,6),cei(miserri,8));
%     while mini>(size(cei,1)-101) && miserri>(size(cei,1)-401) && size(cei,1)<2800% && miniv2>0.00001
%         [ cfi,ceii] = classifytrain(2,1,cfi,traind,trainl(:,fi),testd,testl(:,fi));
%         cei=[cei;ceii(2,:)];
%         [~,mini1]=min(cei(:,1));[miniv2,mini2]=min(cei(:,2));mini=min(mini1,mini2);
%         [miserrv,miserri]=max(cei(:,4));
%         fprintf(1,'%6.6f %6d %6d %6d Right: %6.6f Miss: %6.6f Error: %6.6f\n',cei(end,2),mini,miserri,size(cei,1),cei(miserri,4),cei(miserri,6),cei(miserri,8));
%         if 0%input('BREAK(0=NO/1=YES):');
%             break;
%         end
%     end
%     clf;plot(cei(2:end,1),'r'),hold on;plot(cei(2:end,2),'b'),hold off;legend('Train','Test');pause;
%     classifier{fi,1}=cfi{1,1};
%     classerr{fi,1}=cei;
%     [~,epoch]=min(cei(:,2));
%     classreault(fi,:)=cei(epoch,:);
%     clear cei ceii cfi epoch mini mini1 mini2 miniv2 miserri miserrv
% end
% clear fi;
% save OCON.mat
% load OCON.mat;
% classifierM=zeros(22,21);
% for i=1:21
%     classifierM(:,i)=classifier{i,1};
% end
% out=1./(1+exp(0-[testd,ones(4800,1)]*classifierM));
% misserr=zeros(22,22);
% for i=1:4800
%     li=22;
%     for ii=1:21
%         if testl(i,ii)
%             li=ii;
%             break;
%         end
%     end
%     oj=22;omax=0.5;
%     for ii=1:21
%         if out(i,ii)>omax
%             omax=out(i,ii);
%             oj=ii;
%         end
%     end
%     misserr(li,oj)=misserr(li,oj)+1;
% end
%
figure(1);
r=(0:0.001:2)*pi;
 x=0.5*0.5*cos(r)+1.4;
 y=0.5*sin(r)+18;
patch(x,y,[0.66,0,0],'edgecolor','none','facealpha',1);
fs=[4,6,7,20,1,2,18,17,21,5,13,22,8,19,10,11,12,14,9,15,3,16];
for i=1:22
    for j=1:22
        if misserr(fs(i),j)>0
            or=0.5*(misserr(fs(i),j)^0.5);
            x=0.5*or*cos(r)+i;
            y=or*sin(r)+23-j;
            if fs(i)==j
%                 patch(x,y,[0,0,0.66],'edgecolor','none','facealpha',1);
            else                
                patch(x,y,[0.66,0,0],'edgecolor','none','facealpha',1);
            end
        end
    end
end
% hold off;
% view(3);
axis([0.5,22.5,0,23]); 
% xlable=cell(1,6);
% for i=1:5
%     if (i*4-3)<10
%         xlable{1,i}=['Fault0',num2str(i*4-3)];
%     else
%         xlable{1,i}=['Fault',num2str(i*4-3)];
%     end
% end
% xlable{1,6}='Normal';
set(gca, 'XTick',1:22);
% set(gca, 'XTicklabel',xlable); 
ylable=cell(1,22);
ylable{1,1}='New';
ylable{1,2}='Normal';
for i=3:22
    if (23-i)<10
        ylable{1,i}=['Fault0',num2str(23-i)];
    else
        ylable{1,i}=['Fault',num2str(23-i)];
    end
end
set(gca, 'YTick',1:22 );
set(gca, 'YTicklabel',ylable);
