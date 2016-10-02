function showtrainprocess( layer,ls)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
legend1=cell(ls,1);
legend2=cell(ls*2,1);
for li=1:ls
    subplot(1,3,1),plot(layer{li,6}),hold on;plot(layer{li,7}),hold on;
    subplot(1,3,2),plot(layer{li,8}),hold on;plot(layer{li,9}),hold on;
    subplot(1,3,3),plot(layer{li,9}-layer{li,8}),hold on;
    legend1{li}=['Layer ',num2str(li),'-',num2str(li+1),' (',num2str(layer{li,1}),'-',num2str(layer{li,2}),')'];
    legend2{li*2-1}=['Layer ',num2str(li),'-',num2str(li+1),' Training'];
    legend2{li*2}=['Layer ',num2str(li),'-',num2str(li+1),' Validation'];
end
subplot(1,3,1),hold off;legend(legend2);
subplot(1,3,2),hold off;legend(legend2);
subplot(1,3,3),hold off;legend(legend1);
end

