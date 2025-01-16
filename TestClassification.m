
clc;clear;close;
% dataNames ={'Indian_pines','Salinas','PaviaU'};
dataNames ={'Indian_pines'};
for dataName = dataNames
load(['MYresult/',dataName{1},'.mat']);
% Solutions = cell2mat(struct2cell(load(['MYresult/',dataName{1},'.mat'])));
Solutions = SVMfinpop;
%     Fulllabel = cell2mat(struct2cell(load(['../dataset/',dataname,'_gt.mat'])));
KNNfinresult = zeros(size(Solutions,1),3);
% KNNfinpop = zeros(endN - startN + 1,size(grayValue,2));
SVMfinresult = zeros(size(Solutions,1),3);
RDFfinresult = zeros(size(Solutions,1),3);
for i = 1:1 %size(Solutions,1)
    
    [KNNfinresult(i,:),SVMfinresult(i,:),RDFfinresult(i,:)] = testAcc(Solutions(i,:),dataName{1});

end
% save(['MYresult/','result/',dataName{1}],'KNNfinresult','SVMfinresult','RDFfinresult');
end

% clc;clear;close;
% dataNames ={'Indian_pines','Salinas','PaviaU'};
% % dataNames ={'PaviaU'};
% for dataName = dataNames
% Solutions = cell2mat(struct2cell(load(['MYVARMI/',dataName{1},'.mat'])));
% %     Fulllabel = cell2mat(struct2cell(load(['../dataset/',dataname,'_gt.mat'])));
% KNNfinresult = zeros(size(Solutions,1),3);
% % KNNfinpop = zeros(endN - startN + 1,size(grayValue,2));
% SVMfinresult = zeros(size(Solutions,1),3);
% for i = 1:size(Solutions,1)
%     
%     [KNNfinresult(i,:),SVMfinresult(i,:)] = testAcc(Solutions(i,:),dataName{1});
% 
% end
% save(['MYVARMI/','result/',dataName{1}],'KNNfinresult','SVMfinresult');
% end