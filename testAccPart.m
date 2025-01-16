function [KNNresult] = testAccPart(X,dataname)
runtimes = 1;
accKNN = zeros(runtimes,3);
for runtime = 1:runtimes
    % load fulldata
    Fulldata = cell2mat(struct2cell(load(['../dataset/',dataname,'_corrected.mat'])));
    Fulllabel = cell2mat(struct2cell(load(['../dataset/',dataname,'_gt.mat'])));
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
    
    
    labeledData = fulldata(fulllabel ~=0,:);
    labeledLabel = fulllabel(fulllabel ~=0);
    if exist(['predata/',dataname,'_wrapperIndex.mat'],'file')==0
        ax = 10;
        wrapperIndex = [];
        classNum = length(unique(labeledLabel));
        for i = 1:classNum
            oneclass = find(labeledLabel==i);
            if(length(oneclass)>ax)
                wrapperIndex = [wrapperIndex;oneclass(randperm(length(oneclass),ax))];
            else
                wrapperIndex = [wrapperIndex;oneclass];
            end
        end
        save(['predata/',dataname,'_wrapperIndex'],'wrapperIndex');
    else
        load(['predata/',dataname,'_wrapperIndex.mat']);
    end
    
    trainIndex = rand(size(labeledLabel,1),1)>2;
    trainIndex(wrapperIndex) = 1;
    testIndex = trainIndex;
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
    
end
KNNresult = accKNN;
end