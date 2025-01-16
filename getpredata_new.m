function [fulldata,fulllabel,nearpoint,MI,SSIM,MS,Results_segment,L,Lnear,GLA] = getpredata_new(dataname)
    
    % load fulldata
    Fulldata = cell2mat(struct2cell(load(['../dataset/',dataname,'_corrected.mat'])));
    Fulllabel = cell2mat(struct2cell(load(['../dataset/',dataname,'_gt.mat'])));
    x = size(Fulldata);
    
    % reshape the data to instanceN * bandsN
    fulldata = reshape(Fulldata,x(1)*x(2),x(3));
    fulllabel = reshape(Fulllabel,x(1)*x(2),1);
    
    % normalization
    mindata = min(fulldata,[],1);
    maxdata = max(fulldata,[],1);
    
    % grayValue
    grayValue = (fulldata-mindata)./(maxdata-mindata).*255+1;
%     grayValue = (fulldata-mindata)./(maxdata-mindata);
    % data to original size
    grayValues = reshape(uint8(grayValue),x(1),x(2),x(3));
%     grayValues = reshape(grayValue,x(1),x(2),x(3));
    
    % Super-pixel-segment K =300
    K = 500;
    Results_segment = 0;
%     Results_segment = ersForHID((double(grayValues)-1)/255,K); 
%     Results_segment = ersForHID(double(grayValues),K); 
%     Results_segment = ersForHID(grayValues,K); 
    
    
   

    fulldata = grayValue;
%     fulldata = (grayValue-1)/255;
    
    %% calculate the Square variance matrix MS
    % Expand two rows and two columns 
    % Expand the matrix to get adjacent pixels
    helpm = zeros(x(1)+2,x(2)+2,x(3));
    helpm(2:end-1,2:end-1,:) = grayValues;
    helpdata = reshape(helpm,(x(1)+2)*(x(2)+2),x(3));
       

    helplabel = zeros(x(1)+2,x(2)+2,1);
    helplabel(2:end-1,2:end-1,:) = Fulllabel;
    helpzeroslabel = reshape(helplabel,(x(1)+2)*(x(2)+2),1);
    

    Idx = find(helpzeroslabel ~= 0);
    if length(Idx)<30000 
        xs = 0.1;
    elseif length(Idx)>100000
        xs = 0.005;
    else 
        xs = 0.05;
    end
    choicenum = ceil(xs*length(Idx));
    randIdx = randperm(length(Idx),choicenum);
    randIdx1 = randperm(length(Idx),choicenum);
    Idx1 = Idx(randIdx1);
    Idx = Idx(randIdx);
    
    nearpoint = zeros(8*length(Idx),x(3));
    
    % Take eight fields unlabeled with zeros and auxiliary values
    for i = 1:sum(length(Idx))
        s1 = helpdata(Idx(i)-x(1)-3:Idx(i)-x(1)-1,:);
        s2 = [helpdata(Idx(i)-1,:);helpdata(Idx(i)+1,:)];
        s3 = helpdata(Idx(i)+x(1)+1:Idx(i)+x(1)+3,:);
        s = [s1;s2;s3];
        ss = find(sum(s,2)==0);
%         s(ss,:) = repmat(helpdata(Idx(i),:),length(ss),1);
        s(ss,:) = repmat(zeros(1,x(3)),length(ss),1);
        nearpoint(i*8-7:i*8,:) = s;
    end
    
    MS = zeros(length(Idx),x(3),8);
    for i = 1:8
        MS(:,:,i) = (helpdata(Idx,:)-nearpoint(8*(1:length(Idx))-8+i,:)).^2;
    end
    
    %% Compute the Laplace matrix
%     GLA = grayValue(randperm(size(grayValue,1),5000),:);  % random pixels
%     GLA = nearpoint;
    GLA = helpdata(Idx1,:);
    DisA = pdist2(GLA,GLA);
    TDisA = sort(DisA,2,'descend');
    TDisA1 = sort(DisA,2);
%     k = ceil(size(GLA,1)/8);
    k = 5;
    k1 = 9;
    Smn = zeros(size(DisA,1));
    D   = zeros(size(DisA,1));
    Smnnear = zeros(size(DisA,1));
    Dnear   = zeros(size(DisA,1));
    for m = 1:size(DisA,1)
        for n = m+1:size(DisA,1)
            if DisA(m,n)>TDisA(m,k1)
%                 Smn(m,n) = (TDisA(m,k+1)-DisA(m,n))/(sum(DisA(m,1:n))-sum(TDisA(m,1:k+1)));
%                 Smnnear(m,n) = (TDisA(m,k+1)-DisA(m,n))/(sum(DisA(m,1:n))-sum(TDisA(m,1:k+1)));
                Smn(m,n) = (TDisA(m,k1+1)-DisA(m,n))/(k1*TDisA(m,k1+1)-sum(DisA(m,1:n)));
                Smn(n,m) = Smn(m,n);
            end
        end
        D(m,m) = sum(Smn(m,:));
    end
    L = D-Smn;
    for m = 1:size(DisA,1)
        for n = m+1:size(DisA,1)
            if DisA(m,n)<TDisA1(m,k)
                Smnnear(m,n) = (TDisA1(m,k+1)-DisA(m,n))/(k*TDisA1(m,k+1)-sum(TDisA(m,1:n)));
%                 Smnnear(m,n) = exp(-DisA(m,n));
                Smnnear(n,m) = Smnnear(m,n);
            end
        end
        Dnear(m,m) = sum(Smnnear(m,:));
    end
    Lnear = Dnear-Smnnear;
    
    %% calculate the MI
    if exist(['../newfixdata/',dataname,'_MI.mat'],'file')==0
        MI = CalcMI(uint8(grayValue));
        % MI = corr(grayValue);
        save(['../newfixdata/',dataname,'_MI'],'MI');
    else
        % MI = corr(grayValue);
        load(['../newfixdata/',dataname,'_MI.mat']);
    end
    
        %% calculate the SSIM
    if exist(['../newfixdata/',dataname,'_SSIM.mat'],'file')==0
        SSIM = CalcSSIM(grayValue);
        % MI = corr(grayValue);
        save(['../newfixdata/',dataname,'_SSIM'],'SSIM');
    else
        % MI = corr(grayValue);
        load(['../newfixdata/',dataname,'_SSIM.mat']);
    end
    
    
    
    
    
    
    
    
%     notzero =helpzeroslabel~=0;
%     if exist(['newfixdata/',dataname,'Index.mat'],'file')==0
%         index1 = rand(x(1)+2,x(2)+2,1)>0.1;
%         index = reshape(index1,(x(1)+2)*(x(2)+2),1);
%         testIndex = notzero&index;
%         trainIndex = notzero&(~index);
%         save(['../newfixdata/',dataname,'Index'],'testIndex','trainIndex');
%     else
%         load(['../newfixdata/',dataname,'Index.mat']);
%     end
%     
% %     helpdata(~notzero,:) = 0;
% 
%     %训练集和测试�?
%     testData = helpdata1(testIndex,:);
%     testLabel = helplabel(testIndex);
%     trainData = helpdata1(trainIndex,:);
%     trainLabel = helplabel(trainIndex);
% 
%     mindata1 = min(helpdata1,[], 1);
%     maxdata1 = max(helpdata1,[], 1);
%     trainData = (trainData-mindata1)./(maxdata1-mindata1);
%     testData = (testData-mindata1)./(maxdata1-mindata1);
% 
%         
%     
%     
%     Idx = find(helpzeroslabel1~=-1);
%     choicenum = ceil(0.02*length(Idx));
%     randIdx = randperm(length(Idx),choicenum);
%     Idx = Idx(randIdx);
%     nearpoint = zeros(8*length(Idx),x(3));
%     %取八个领域除去标签为0和辅助�??
%     for i = 1:sum(length(Idx))
%         s1 = helpdata(Idx(i)-x(1)-3:Idx(i)-x(1)-1,:);
%         s2 = [helpdata(Idx(i)-1,:);helpdata(Idx(i)+1,:)];
%         s3 = helpdata(Idx(i)+x(1)+1:Idx(i)+x(1)+3,:);
%         s = [s1;s2;s3];
%         ss = find(sum(s,2)==0);
%         s(ss,:) = repmat(fulldata(randIdx(i),:),length(ss),1);
%         nearpoint(i*8-7:i*8,:) = s;
%     end
    


%     mindata = min([testData;trainData],[], 1);
%     maxdata = max([testData;trainData],[], 1);
%     trainData = (trainData-mindata)./(maxdata-mindata);
%     testData = (testData-mindata)./(maxdata-mindata);
%     nearpoint = (nearpoint-mindata)./(maxdata-mindata);
    
    
%     %% 计算平方�?
%     MS = zeros(length(Idx),x(3),8);
%     for i = 1:8
%         MS(:,:,i) = (fulldata(randIdx,:)-nearpoint(8*(1:length(Idx))-8+i,:)).^2;
%     end
%     if exist(['../newfixdata/',dataname,'_MI.mat'],'file')==0
% %         MI = CalcMI(trainData(randperm(size(trainData,1),500),:));
% %         MI = CalcMI(uint8(grayValue(fulllabel~=0,:)));
%         MI = CalcMI(uint8(grayValue));
% %         MI = corr(grayValue);
%         save(['../newfixdata/',dataname,'_MI'],'MI');
%     else
% %         MI = corr(grayValue);
%         load(['../newfixdata/',dataname,'_MI.mat']);
%     end
% %     if exist(['../newfixdata/',dataname,'_MI.mat'],'file')==0
% %         MI = CalcMI(trainData(randperm(size(trainData,1),500),:));
% % %         MI = corr(trainData);
% %         save(['../newfixdata/',dataname,'_MI'],'MI');
% %     else
% % %         MI = corr(trainData);
% %         load(['../newfixdata/',dataname,'_MI.mat']);
% %     end
end