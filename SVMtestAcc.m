function acc = SVMtestAcc(trainData, trainLabel, testData, testLabel, X)
	%% Test On SVM
	X = X > 0.5;
    Category = unique(trainLabel);
    if (sum(X) == 0)
        acc = [0,0];
        return;
    end

    try
        
        tic;

        %寻找最优c和g
        %粗略选择：c&g 的变化范围是 2^(-10),2^(-9),...,2^(10)
%         [bestacc,bestc,bestg] = SVMcgForClass(trainLabel,trainData(:, X),0,20,-20,0);
        %精细选择：c 的变化范围是 2^(-2),2^(-1.5),...,2^(4), g 的变化范围是 2^(-4),2^(-3.5),...,2^(4)
%         [bestacc,bestc,bestg] = SVMcgForClass(trainLabel,trainData(:, X),-2,4,-4,4,3,0.5,0.5,0.9);

        toc;

        %训练模型
%          cmd=('-s 0 -t 2 -c 500 -b 1 -g 0.05 ');
        cmd=('-s 0 -t 2 -c 2048 -g 0.07 ');
%         cmd = ['-s 0 -t 2' , '-c ',num2str(bestc),' -g ',num2str(bestg)];
        model=svmtrain(trainLabel,trainData(:, X),cmd);
        disp(cmd);
        
        
%         model = svmtrain(trainLabel,trainData(:, X),'-s 0 -t 2 -c 5000 -g 0.1');
%         err_rate = SVMmulti(trainData(:, X), testData(:, X), trainLabel, testLabel, Category);
    catch err
        disp(err);
        acc = [0,0];
    return;
    end
    [y, accuracy, ~] =svmpredict(testLabel, testData(:, X), model);
	y1 = y == testLabel;
	acc1 = sum(y1) / numel(y);
    part = zeros(length(unique(testLabel)),1);
    for i = 1:length(unique(testLabel))
        part(i,1) = sum(testLabel==i)*sum(y == i);
    end
    kappa = (numel(y)*sum(y1)-sum(part))/(numel(y1)^2-sum(part));
    acc = [acc1,kappa];
end

% multi-class
function err_rate = SVMmulti(train_data, test_data, train_target, test_target, Category)
    Prob_label = cell(1, numel(Category));
    for ii = 1:numel(Category)
        SVMModel = fitcsvm(train_data,train_target==Category(ii));
        [predict_label, scores] = predict(SVMModel,test_data);
        if ~any(predict_label) && size(scores, 2)==1
            Prob_label{ii} = -inf.*ones(size(scores, 1),1);
        elseif all(predict_label) && size(scores, 2)==1
            Prob_label{ii} = scores(:, 1);
        else
            Prob_label{ii} = scores(:, 2);
        end
    end
    Prob_label_mat = cell2mat(Prob_label); % each column represents probability of belonging to each label
    [~, tmpInx] = max(Prob_label_mat, [], 2);
    err_rate = mean(Category(tmpInx)~=test_target);
end

