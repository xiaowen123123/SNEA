clc; clear; close all;

% dataNames ={'Indian_pines','Salinas','PaviaU'};
%  dataNames ={'Salinas','PaviaU'};
  dataNames = {'Houston'};
% dataNames ={'Salinas'};
for dataName = dataNames
    disp(dataName);
    
    %% Processing data, normalization, pre-processing data, mutual information, nearest neighbor distance, super-pixel segmentation results
    [grayValue,fulllabel,nearpoints,MI,SSIM,MS,Results_segment,L,Lnear,GLA] = getpredata_new(dataName{1});
    
    startN = 4;
    endN = 60;
    KNNfinresult = zeros(endN - startN + 2,2);
    choiceIndex = zeros(endN - startN + 2,5);
    differentResults = zeros(endN - startN + 2,5);

    KNNfinpop = zeros(endN - startN + 1,size(grayValue,2));
    
    KNNfinpopmax = zeros(endN - startN + 1,size(grayValue,2));
    
    SVMfinresult = zeros(endN - startN + 2,2);
    SVMfinpop = zeros(endN - startN + 1,size(grayValue,2));
   
    allBands = ones(1,size(grayValue,2))>0;
    Fulldata = cell2mat(struct2cell(load(['../dataset/',dataName{1},'_corrected.mat'])));
    Fulllabel = cell2mat(struct2cell(load(['../dataset/',dataName{1},'_gt.mat'])));
    [KNNacc,SVMacc] = testAcc(allBands,dataName{1},Fulldata,Fulllabel);
%     KNNacc = [0,0,0];
%     SVMacc = [0,0,0];
    KNNfinresult(end,2) = size(grayValue,2);
    KNNfinresult(end,[1,3,4]) = KNNacc;
    SVMfinresult(end,2) = size(grayValue,2);
    SVMfinresult(end,[1,3,4]) = SVMacc;
    
    resultTest = zeros(endN - startN + 2,5);
    sortResult = zeros(1,5);
        %% MOCSO_BS
        tic;
%         T = zeros(endN - startN + 1,size(grayValue,2));
        for n = 1:endN - startN + 1
            % BS
%             T(n,:) = Group(grayValue,startN+n-1);
            T = Group(grayValue,startN+n-1);
%             T = Group(grayValue,30);
            [pfs,pobjs] = MOCSO(grayValue,fulllabel,startN+n-1,MI,SSIM,nearpoints,MS,T,Results_segment,L,Lnear,GLA);
%             pfs = pfs1(end,:);
            % Test the OA AA Kappa
            KNNacc = zeros(size(pfs,1),3);
            SVMacc = zeros(size(pfs,1),3);
            
            for j = 1:size(pfs,1)
                [KNNacc(j,:),SVMacc(j,:),~] = testAcc(pfs(j,:),dataName{1},Fulldata,Fulllabel);
            end
            
            [KNNfinresult(n,1),indpop] = max(KNNacc(:,1));
            KNNfinresult(n,[2,3,4]) = [startN+n-1,KNNacc(indpop,[2,3])];
            KNNfinpopmax(n,:) = pfs(indpop,:);
            KNNfinpop(n,:) = pfs(end,:);
            figure(3);
            bandDist(KNNfinpop(n,:));
            hold on;
            %test choice
            [~,index] = sort(pobjs,1);
            for ii = 1:5
                sortResult(ii) = find(index(:,ii) == indpop);
            end
            
            resultTest(n,:) = sortResult;
            
            [SVMfinresult(n,1),Sindpop] = max(SVMacc(:,1));
            SVMfinresult(n,[2,3,4]) = [startN+n-1,SVMacc(Sindpop,[2,3])];
            SVMfinpop(n,:) = pfs(Sindpop,:);
%             save(['testChoice/','1120/',dataName{1},'/all/acc/',num2str(startN+n-1)],'KNNacc');
%             save(['testChoice/','1120/',dataName{1},'/all/pop/',num2str(startN+n-1)],'pfs');
            %按照不同的�?��?�解
            [~,choiceIndex(n,1)] = min(pobjs(:,1));
            [~,choiceIndex(n,2)] = min(pobjs(:,2));
            [~,choiceIndex(n,3)] = max(pobjs(:,3));
            [~,choiceIndex(n,4)] = min(pobjs(:,4));
            [~,choiceIndex(n,5)] = max(pobjs(:,5));
            for iii = 1:5
                differentResults(n,iii) = KNNacc(choiceIndex(n,iii),1);
            end
        end
%         save(['testChoice/','1120/',dataName{1},'/all/aindex'],'choiceIndex');
%         save(['testChoice/','1120/',dataName{1},'/all/Results'],'differentResults');
        toc;
end     
%             testfigure(KNNfinresult,0,1);
            
            %% sava result
%              save(['result/',dataName{1},'/','MY66'],'KNNfinresult','SVMfinresult');
%              save(['result/',dataName{1},'/','MYtest'],'KNNfinpop','KNNfinpopmax');
%              save(['testChoice/','1115/',dataName{1},'/',dataName{1}],'KNNfinpop');
%              save(['testChoice/','1115/',dataName{1}],'KNNfinpopmax');
%              save(['testChoice/','1115/',dataName{1}],'KNNfinresult');
%                xlswrite('result/',dataName{1},'/','MYVarMI',mean(KNNfinresult(1:end-1,:)));
%                log = fopen('log.txt','a');
%                fprintf(log,"MY2:使用使用流形和领域距离进行计算，算子使用原始算子\n");
%                formatSpec = '数据集是：\t %sKNN_mean is : \t%4.2f \nSVM_mean is \t%4.2f \n\n';
%                fprintf(log,formatSpec,dataName{1},mean(KNNfinresult(1:end-1,1)),mean(SVMfinresult(1:end-1,1)));
%                fclose(log);
        