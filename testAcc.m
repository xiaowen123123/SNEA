function [KNNresult,SVMresult,RDFresult] = testAcc(X,dataname,Fulldata,Fulllabel)
runtimes = 1;
accKNN = zeros(runtimes,3);
accSVM = zeros(runtimes,3);
accRDF = zeros(runtimes,3);
for runtime = 1:runtimes
    % load fulldata

%     Fulldata = cell2mat(struct2cell(load(['../dataset/',dataname,'_corrected.mat'])));
%     Fulllabel = cell2mat(struct2cell(load(['../dataset/',dataname,'_gt.mat'])));
    x = size(Fulldata);
    
    % reshape the data to instanceN * bandsN
    fulldata = reshape(double(Fulldata),x(1)*x(2),x(3));
    fulllabel = reshape(double(Fulllabel),x(1)*x(2),1);
    
    % Divide training set and testing set
    
    labeledData = fulldata(fulllabel ~=0,:);
    labeledLabel = fulllabel(fulllabel ~=0);

    % normalization
    mindata = min(labeledData,[],1);
    maxdata = max(labeledData,[],1);
    labeledData = (labeledData-mindata)./(maxdata-mindata);
    if size(labeledData,1)>40000
        ax = 0.1;
    else
        ax = 0.1;
    end
    if exist(['../newfixdata/',dataname,'Index.mat'],'file')==0
        trainIndex = rand(size(labeledLabel,1),1)<ax;
        testIndex = ~trainIndex;
        save(['../newfixdata/',dataname,'Index'],'testIndex','trainIndex');
    else
%         trainIndex = rand(size(labeledLabel,1),1)<ax;
%         testIndex = ~trainIndex;
        load(['../newfixdata/',dataname,'Index.mat']);
    end

    
    trainData = labeledData(trainIndex,:);
    trainLabel = labeledLabel(trainIndex);
    testData = labeledData(testIndex,:);
    testLabel = labeledLabel(testIndex);
    
	
	X = X > 0.6;
    if sum(X) == 0
        acc1 = 0;
        return;
    end
    
    %% Test On KNN
	knnK = 5;
	try
		mdl = ClassificationKNN.fit(trainData(:, X), trainLabel, 'NumNeighbors', knnK);
	catch err
		acc1 = 0;
		return;
	end
	y = predict(mdl, testData(:, X));
    
    % OA
	y1 = y == testLabel;
	acc1 = sum(y1) / numel(y);
    
    % kappa
    part = zeros(length(unique(testLabel)),1);
    for i = 1:length(unique(testLabel))
        part(i,1) = sum(testLabel==i)*sum(y == i);
    end
    kappa = (numel(y)*sum(y1)-sum(part))/(numel(y1)^2-sum(part));
    
    % AA
    part1 = zeros(length(unique(testLabel)),1);
    for i = 1:length(unique(testLabel))
        y1 = sum((y == i) + (testLabel == i)==2);
        part1(i,1) = y1/sum(testLabel==i);
    end
    aa = mean(part1);
    
    accKNN(runtime,:) = [acc1,kappa,aa];

    %% Test On SVM
    
%     cmd=('-s 0 -t 2 -c 5000 -g 0.1 ');
% %     [bestacc,bestc,bestg] = SVMcgForClass(trainLabel,trainData(:, X),6,20,-20,0);
% %     cmd = ['-s 0 -t 2' , '-c ',num2str(bestc),' -g ',num2str(bestg)];
% %     cmd=('-s 0 -t 2 -c 500 -b 1 -g 0.05 ');
% 
%      model=svmtrain(trainLabel,trainData(:, X),cmd);
%      [y, accuracy, ~] =svmpredict(testLabel, testData(:, X), model);
%     %y = testLabel;
%     % OA
% 	y1 = y == testLabel;
% 	acc1 = sum(y1) / numel(y);
%     
%     % kappa
%     part = zeros(length(unique(testLabel)),1);
%     for i = 1:length(unique(testLabel))
%         part(i,1) = sum(testLabel==i)*sum(y == i);
%     end
%     kappa = (numel(y)*sum(y1)-sum(part))/(numel(y1)^2-sum(part));
%     
%     % AA
%     part1 = zeros(length(unique(testLabel)),1);
%     for i = 1:length(unique(testLabel))
%         y1 = sum((y == i) + (testLabel == i)==2);
%         part1(i,1) = y1/sum(testLabel==i);
%     end
%     aa = mean(part1);
    accSVM(runtime,:) = [0,0,0];
%     accSVM(runtime,:) = [acc1,kappa,aa];

    %% Test On RDF
% %     depth = 11;
%     numTrees = 30;
%     B = TreeBagger(numTrees,trainData(:,X),trainLabel, 'Method', 'classification');
% %     opts = RFopts(depth,numTrees);
% %     model = forestTrain(trainData(:,X),trainLabel,opts);
% %     y = forestTest(model,testData(:,X));
%     ycell = B.predict(testData(:,X));
%     y = cell2mat(ycell(:,1));
%     % OA
% 	y1 = y == testLabel;
% 	acc1 = sum(y1) / numel(y);
%     
%     % kappa
%     part = zeros(length(unique(testLabel)),1);
%     for i = 1:length(unique(testLabel))
%         part(i,1) = sum(testLabel==i)*sum(y == i);
%     end
%     kappa = (numel(y)*sum(y1)-sum(part))/(numel(y1)^2-sum(part));
%     
%     % AA
%     part1 = zeros(length(unique(testLabel)),1);
%     for i = 1:length(unique(testLabel))
%         y1 = sum((y == i) + (testLabel == i)==2);
%         part1(i,1) = y1/sum(testLabel==i);
%     end
%     aa = mean(part1);
%     
    accRDF(runtime,:) = [0,0,0];
%     accRDF(runtime,:) = [acc1,kappa,aa];
end
% KNNresult = mean(accKNN);
% SVMresult = mean(accSVM);
% RDFresult = mean(accRDF);
KNNresult = accKNN;
SVMresult = accSVM;
RDFresult = accRDF;
end