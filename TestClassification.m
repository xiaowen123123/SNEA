clc;clear;close;
dataNames ={'Indian_pines'};
for dataName = dataNames
    load(['MYresult/',dataName{1},'.mat']);
    Solutions = SVMfinpop;
    KNNfinresult = zeros(size(Solutions,1),3);
    SVMfinresult = zeros(size(Solutions,1),3);
    RDFfinresult = zeros(size(Solutions,1),3);
    
    for i = 1:1 %size(Solutions,1)
        [KNNfinresult(i,:),SVMfinresult(i,:),RDFfinresult(i,:)] = testAcc(Solutions(i,:),dataName{1});
    end
end