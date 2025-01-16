clc;clear;close all;
% dataNames ={'Indian_pines','Salinas','PaviaU'};
dataNames ={'PaviaU'};
for dataName = dataNames
    %加载选择的索引
    %通过选取一小部分样本来计算精度选择精度最高的解
    n = 57;
    load(['testChoice/1115/',dataName{1},'/all/pop/',num2str(4)],'pfs');
    KNNfinresult = zeros(n,2);
    KNNfinresult1 = zeros(n,2);
    KNNacc1 = zeros(size(pfs,1),3);
    KNNfinpop = zeros(57,size(pfs,2));
    for i = 1:n
        disp(num2str(i));
        load(['testChoice/1115/',dataName{1},'/all/pop/',num2str(i+3)],'pfs');
        load(['testChoice/1115/',dataName{1},'/all/acc/',num2str(i+3)],'KNNacc');
        for j = 1:size(pfs,1)
            KNNacc1(j,:) = testAccPart(pfs(j,:),dataName{1});
        end
        [KNNfinresult(i,1),indpop] = max(KNNacc1(:,1));
        KNNfinresult1(i,1) = KNNacc(indpop,1);
%         KNNfinresult1(i,1) = max(KNNacc(:,1));
        KNNfinpop(i,:) = pfs(indpop,:);
    end

%     save(['1115/',dataName{1},'/all/',dataName{1}],'KNNfinpop');
end