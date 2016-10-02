%
clear all;
faulti=14;
tagn=50:-5:5;
timen=[20,16,13,10,8,6,4,3,2,1];
ces=zeros(size(tagn,2),size(timen,2),8);
for i=1:size(tagn,2)
    for j=1:size(timen,2)
        load(['D:\ZhangProject\mat\matf',num2str(faulti),'\teline',num2str(timen(j)),'-',num2str(tagn(i)),'-',num2str(faulti),'.mat'],'layer','wserr','classerr');
        [miserr2v,miserr2i]=max(classerr(:,4));%min(classerr(:,6)+classerr(:,8));
        miserr1i=miserr2i;
        miserr1v=classerr(miserr2i,3);
        for mi=miserr2i:size(classerr,1)
            if classerr(mi,4)==miserr2v
                if miserr1v<classerr(mi,3)
                    miserr1v=classerr(mi,3);
                    miserr1i=mi;
                end
            end
        end
        min2i=miserr1i;
        min2v=classerr(miserr1i,2);
        for mi=miserr2i:size(classerr,1)
            if classerr(mi,3)==miserr1v && classerr(mi,4)==miserr2v
                if min2v>classerr(mi,2)
                    min2v=classerr(mi,2);
                    min2i=mi;
                end
            end
        end        
        mini=min2i;
%         [~,mini]=min(classerr(:,2));
%         mini=size(classerr,1);
        if tagn(i)==35 && timen(j)==6
%             mini1
%             mini2
% mini
% classerr(end,:)
%         end
%             clf;showtrainprocess(layer,size(layer,1));pause;
%             clf;plot(wserr(:,1),'r'),hold on;plot(wserr(:,2),'b'),hold off;legend('Train','Test');pause;
%             clf;plot(classerr(:,1),'r'),hold on;plot(classerr(:,2),'b'),hold on;plot([mini,mini],[0,classerr(mini,2)]),hold off;legend('Train','Test',num2str(mini));pause;
%             clf;plot(classerr(:,3),'r'),hold on;plot(classerr(:,4),'b'),hold on;plot([mini,mini],[0,classerr(mini,4)]),hold off;legend('Train','Test',[num2str(mini),'/',num2str(size(classerr,1))]);pause;
%             clf;plot(classerr(:,5),'r'),hold on;plot(classerr(:,6),'b'),hold on;plot([mini,mini],[0,classerr(mini,6)]),hold off;legend('Train','Test',num2str(mini));pause;
%             clf;plot(classerr(:,7),'r'),hold on;plot(classerr(:,8),'b'),hold on;plot([mini,mini],[0,classerr(mini,8)]),hold off;legend('Train','Test',num2str(mini));pause;
        end
            ri=mini;%input('Chose epoch:');
            ces(i,j,1)=classerr(ri,1);
            ces(i,j,2)=classerr(ri,2);
            ces(i,j,3)=classerr(ri,3);
            ces(i,j,4)=classerr(ri,4);
            ces(i,j,5)=classerr(ri,5);
            ces(i,j,6)=classerr(ri,6);
            ces(i,j,7)=classerr(ri,7);
            ces(i,j,8)=classerr(ri,8);
    end
end
clear classerr i j layer mini mini1 mini2 miserr ri wserr 
subplot(2,4,1),contourf(timen*3,tagn,ces(:,:,1),20);colorbar;
subplot(2,4,2),contourf(timen*3,tagn,ces(:,:,3),20);colorbar;
subplot(2,4,3),contourf(timen*3,tagn,ces(:,:,5),20);colorbar;
subplot(2,4,4),contourf(timen*3,tagn,ces(:,:,7),20);colorbar;
subplot(2,4,5),contourf(timen*3,tagn,ces(:,:,2),20);colorbar;
subplot(2,4,6),contourf(timen*3,tagn,ces(:,:,4),20);colorbar;
subplot(2,4,7),contourf(timen*3,tagn,ces(:,:,6),20);colorbar;
subplot(2,4,8),contourf(timen*3,tagn,ces(:,:,8),20);colorbar;