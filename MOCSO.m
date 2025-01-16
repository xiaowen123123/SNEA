function  [pfs,pobjs] = MOCSO(grayValue,fulllabel,n,MIall,SSIMall,nearpoints,MS,T,Results_segment,L,Lnear,GLA)
    SSIMall = SSIMall+SSIMall';
    M = length(unique(T));
    vargroup = zeros(M,1);
    
    %% Calculate the Var for each group
    figure(1);
    hold on;
    xlim([1,200])
    for i = 1:M
        left = find(T == i,1,'first');
        right = find(T == i,1,'last');
%         plot(repmat(right,10),1:10,'-');
        varpop = ones(1,right-left+1)>0;
        gdata = grayValue(:,left:right);
        vargroup(i) = CalcVar(gdata,varpop); 
    end
    
    %% Var guided population
    popare = zeros(1,size(grayValue,2));
    for i = 1:M
        left = find(T == i,1,'first');
        right = find(T == i,1,'last');
        popare(:,left:right) = rand(1,right-left+1)*vargroup(i)/sum(vargroup);
%         popare(:,left:right) = vargroup(i)/sum(vargroup);
    end
    
    %% Init 	
    featNum = size(grayValue, 2);  	
    maxIt = 50; 	
    popNum = 50;
    num_subset = n; %preset num of feature subset

    pop = zeros(popNum, featNum);
    
%% new Init for each group

    for j = 1:popNum
        for i = 1:M
            left = find(T == i,1,'first');
            right = find(T == i,1,'last');
            index = left+randi(right-left+1);
            if index>featNum
                index = featNum;
            end
            pop(j,index) = 1;
        end
    end
    pop = pop>0.5;
    
    bandnear = zeros(1,featNum);
    bandEntrop = zeros(1,featNum);
    for nearI = 1:featNum
        bandEntrop(nearI) = Entrop(grayValue(:,nearI)');
        bandnear = -bandEntrop;
    end
    nearX = 1:featNum;
    nearY = bandnear;
    plot(nearX,nearY);
    
    %% Calculate the target value
%     [objVar,objEntrop,objTL,objMI,objnear,objInclass]
    [obj1,obj2] = Calcobjs1(grayValue,fulllabel,pop,MIall,SSIMall,nearpoints,MS,Results_segment,GLA,L,Lnear,bandEntrop);
%     [objVar,objMI,near,objInclass,objTL,objFitness] = Calcobjs(grayValue,fulllabel,pop>0.5,MIall,nearpoints,MS,Results_segment,GLA,L,mS,m,nK);    
    P_Obj = [obj1,obj2];
    
%     OffDec = zeros(popNum/2, featNum);

    for it = 1:maxIt
        disp([num2str(n),'selected bands',num2str(it),':it']);
       %% Learning
        % Find winner and loser
        [distributeScore,~] = CalDS_new(pop,bandEntrop,T);
        Fitness = calFitness(P_Obj);
       
        if size(pop,1) >= 2
            Rank = randperm(size(pop,1),floor(size(pop,1)/2)*2);
        else
            Rank = [1,1];
        end
%         [Fitness_srot,I] = sort(Fitness);
%         Loser = I(1:end/2);
%         Winner = I(end/2+1:end);
        Loser  = Rank(1:end/2);
        Winner = Rank(end/2+1:end);
        Change = Fitness(Loser) >= Fitness(Winner);
        Temp   = Winner(Change);
        Winner(Change) = Loser(Change);
        Loser(Change)  = Temp;
        
       %% Figtest
        figure(1);
        set(1,'position',[100,100,640,480] );
        x = P_Obj(Loser,2);
        y = P_Obj(Loser,1);
        x1 = P_Obj(Winner,2);
        y1 = P_Obj(Winner,1);
        plot(x,y,'o','DisplayName',['it:',num2str(it)]);
        hold on;
        plot(x1,y1,'o','DisplayName',['it:',num2str(it)]);
        xlabel('f1:near');
        ylabel('f2:var');
        grid on
        title(['fold',num2str(1)]);
        legend;
        hold off;


        LoserDec  = pop(Loser,:);
        WinnerDec = pop(Winner,:);
        
        
        [N,D]     = size(LoserDec);
        vsf       = zeros(popNum/2, featNum);
        randvsf   = rand(popNum/2, featNum);
        r1        = repmat(ones(N,1),1,D);
        r2        = repmat(ones(N,1),1,D);

%         disDSP    = (distributeScore(Winner)-distributeScore(Loser))./(distributeScore(Winner)+distributeScore(Loser));
        ipij                = WinnerDec-LoserDec;
        loserV = distributeScore(Loser,:);
        tloserV = 1-distributeScore(Loser,:);
        vsf(ipij == 0)      = 0;
%         vsf(ipij == 1)     = ipij(ipij==1).*r1(ipij==1).*loserV(ipij==1);
%         vsf(ipij == -1)    = -ipij(ipij==-1).*r2(ipij==-1).*tloserV(ipij==-1);
        vsf(ipij == 1)     = ipij(ipij==1).*r1(ipij==1).*loserV(ipij==1);
        vsf(ipij == -1)    = -ipij(ipij==-1).*r2(ipij==-1).*tloserV(ipij==-1);


%         OffDec((randvsf<=vsf)&(repmat(popare,size(OffDec,1),1)<=aaa(end-10))) = 0;
%         OffDec((randvsf<=vsf)&(repmat(popare,size(OffDec,1),1)>=aaa(end-10)))  = 1;
%         OffDec(randvsf>vsf)              = LoserDec(randvsf>vsf);
        OffDec             = LoserDec;
        OffDec((randvsf<=vsf)&(ipij == 1)) = 1;
        OffDec((randvsf<=vsf)&(ipij == -1))  = 0;

%         OffDec((randvsf<=vsf)&vsf>0) = 1;
%         OffDec((randvsf<=vsf)&vsf<0)  = 0;
%         OffDec(ipij == 0)              = LoserDec(ipij == 0);
        
        

        
        %% for Winner Local Search
        p1Score = distributeScore(Winner,:);
        ranks = ceil((maxIt-it)/maxIt*((61-n)/57)*(featNum/100));
        for i = 1:size(WinnerDec,1)
            SelIndex = find(WinnerDec(i,:) ==1);
            WinnerDec(i,SelIndex) = 0;
            randSelIndex = randi(D,1,size(SelIndex,2));
            randshake = ceil((1-p1Score(i,SelIndex)).*randi([-ranks,ranks],1,size(SelIndex,2)));
            
            SelIndex = SelIndex + randshake;
            SelIndex(SelIndex<=0|SelIndex>D)  = randSelIndex(SelIndex<=0|SelIndex>D);
            WinnerDec(i,SelIndex) = 1;
        end
%         WinnerDec = WinnerDec|(rand(N,1).*xor(WinnerDec(randperm(N),:),WinnerDec(randperm(N),:)))>0.6;

        pop1 = [OffDec;WinnerDec];

        
        %% fix band number
        for i = 1:popNum
            subset = find(pop1(i,:)==1);
            if length(subset)>n
                subbandnear = bandnear(subset);
%                 subbandnear = sum(MIall(subset,subset));
                [~,subindex] = sort(subbandnear,'descend');
                removeNum = length(subset)-n;
                removeIndex = subindex(1:removeNum);
                pop1(i,subset(removeIndex)) = 0;
                
            elseif length(subset)<n
                subset1 = find(pop1(i,:)==0);
                subbandnear1 = bandnear(subset1);
%                 subbandnear1 = sum(MIall(subset1,subset1));
                [~,subindex1] = sort(subbandnear1);
                addNum = n-length(subset);
                addIndex = subindex1(1:addNum);
                pop1(i,subset1(addIndex)) = 1;
            end
        end


    Offspring = pop1;
    [~,distributeC] = CalDS_new(Offspring,bandEntrop,T);
    initIndex = find(distributeC<(1-n/120));
    Offspring(initIndex,:) = zeros(length(initIndex),featNum);
    for j = 1:length(initIndex)
        for i = 1:M
            left = find(T == i,1,'first');
            right = find(T == i,1,'last');
            index = left+randi(right-left+1);
            if index>featNum
                index = featNum;
            end
            Offspring(initIndex(j),index) = 1;
        end
    end
    Offspring = Offspring>0.5;
    
%     [objVar,objEntrop,objTL,objMI,objnear,objInclass]
    [obj1,obj2] = Calcobjs1(grayValue,fulllabel,Offspring>0.5,MIall,SSIMall,nearpoints,MS,Results_segment,GLA,L,Lnear,bandEntrop);
%     [objVar,objMI,near,objInclass,objTL,objFitness] = Calcobjs(grayValue,fulllabel,pop>0.5,MIall,nearpoints,MS,Results_segment,GLA,L,mS,m,nK);
    P_Obj1 = [obj1,obj2];
    [pop,P_Obj] = EnvironmentalSelection([pop;Offspring],[P_Obj;P_Obj1],popNum);
    clc;
%     figure(5);
%     bandDist(pop);
    end
%     Fitness = calFitness(P_Obj);
%     [~,findIndex] = sort(Fitness,'descend');
% %     [~,bestindex] = max(Fitness);
% 	pfs = pop(findIndex(1:10), :)>0.5;
pop = pop(Winner,:);
P_Obj = P_Obj(Winner,:);
Fitnessfin = calFitness(P_Obj);
    pop = pop>0.5;
%     [FrontNo,~] = NDSort(P_Obj, popNum);
%     finFront1 = FrontNo == 1;
    
% 	pfs = pop(finFront1, :)>0.5;
    pfs = pop>0.5;

    objVar = CalcVar(grayValue,pfs); 
    objMI = CalcJM_MI(grayValue,fulllabel,pfs,MIall);
    
%     pobjs = [P_Obj(finFront1, :),objVar,objMI];
    pobjs = [P_Obj(:,:),objVar,objMI,Fitnessfin];


end