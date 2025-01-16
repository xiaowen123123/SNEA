function [nearpoint,testData,testLabel,trainData,trainLabel,MI,MS] = getpredata(dataname)
    Fulldata = cell2mat(struct2cell(load(['MIdata/',dataname,'_corrected.mat'])));
    Fulllabel = cell2mat(struct2cell(load(['MIdata/',dataname,'_gt.mat'])));
    x = size(Fulldata);
%     Fulldata = (Fulldata-min(min(min(Fulldata))))./(max(max(max(Fulldata)))-min(min(min(Fulldata))));
    %扩充两行两列
    helpm = zeros(x(1)+2,x(2)+2,x(3));
    helpm(2:end-1,2:end-1,:) = Fulldata;
    helpdata = reshape(helpm,(x(1)+2)*(x(2)+2),x(3));
    helplabel = zeros(x(1)+2,x(2)+2,1);
    helplabel(2:end-1,2:end-1,:) = Fulllabel;
    helpzeroslabel = reshape(helplabel,(x(1)+2)*(x(2)+2),1);
    notzero =helpzeroslabel~=0;
    if exist(['fixdata/',dataname,'Index.mat'],'file')==0
        index1 = rand(x(1)+2,x(2)+2,1)>0.1;
        index = reshape(index1,(x(1)+2)*(x(2)+2),1);
        testIndex = notzero&index;
        trainIndex = notzero&(~index);
        save(['fixdata/',dataname,'Index'],'testIndex','trainIndex');
    else
        load(['fixdata/',dataname,'Index.mat']);
    end
    helpdata(~notzero,:) = 0;

    %训练集和测试集
    testData = helpdata(testIndex,:);
    testLabel = helplabel(testIndex);
    trainData = helpdata(trainIndex,:);
    trainLabel = helplabel(trainIndex);



        
    
    Idx = find(trainIndex == 1);
    nearpoint = zeros(8*length(Idx),x(3));
    %取八个领域除去标签为0和辅助值
    for i = 1:sum(length(Idx))
        s1 = helpdata(Idx(i)-x(1)-3:Idx(i)-x(1)-1,:);
        s2 = [helpdata(Idx(i)-1,:);helpdata(Idx(i)+1,:)];
        s3 = helpdata(Idx(i)+x(1)+1:Idx(i)+x(1)+3,:);
        s = [s1;s2;s3];
        ss = find(sum(s,2)==0);
        s(ss,:) = repmat(trainData(i,:),length(ss),1);
        nearpoint(i*8-7:i*8,:) = s;
    end
    


    mindata = min([testData;trainData],[], 1);
    maxdata = max([testData;trainData],[], 1);
    trainData = (trainData-mindata)./(maxdata-mindata);
    testData = (testData-mindata)./(maxdata-mindata);
    nearpoint = (nearpoint-mindata)./(maxdata-mindata);
    
    
    %%计算平方差
    MS = zeros(length(Idx),x(3),8);
    for i = 1:8
        MS(:,:,i) = (trainData-nearpoint(8*(1:length(Idx))-8+i,:)).^2;
    end
    
    
    if exist(['fixdata/',dataname,'_MI.mat'],'file')==0
        MI = CalcMI(trainData(randperm(size(trainData,1),500),:));
%         MI = corr(trainData);
        save(['fixdata/',dataname,'_MI'],'MI');
    else
        load(['fixdata/',dataname,'_MI.mat']);
    end
end