function [ weight ] = defineweight( layer)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
weight = cell(2*size(layer,1),1);
for ni = 1:size(layer,1)
    weight{ni,1} = [layer{ni,3};layer{ni,5}];
    weight{2*size(layer,1)+1-ni,1} = [layer{ni,3}';layer{ni,4}];
end
% for wi=1:size(weight,1)
%     wei=weight{wi,1};
%     hstd=diag(wei(1:end-1,:)'*cov(vdata)*wei(1:end-1,:));hstd=(hstd').^0.5;
%     wei=wei./(ones(size(wei,1),1)*hstd);
%     vdata = [vdata,ones(size(vdata,1),1)]*wei;
%     %plot(std(data));pause;
%     weight{wi,1}=wei;
% %     vdata=vdata./(ones(size(vdata,1),1)*std(vdata));
% end
end

