function distributeScore = CalDS(pop,data,T)
    M = length(unique(T));
    vargroup = zeros(M,1);
    numpop = zeros(size(pop,1),M);
    for i = 1:M
        left = find(T == i,1,'first');
        right = find(T == i,1,'last');
        varpop = ones(1,right-left+1)>0;
        numpop(:,i) = sum(pop(:,left:right),2)/(right-left+1);
        gdata = data(:,left:right);
        vargroup(i) = CalcVar(gdata,varpop); 
    end
    vargroup = vargroup./sum(vargroup);
    [groupRank,rank] = sort(vargroup,'descend');
    score = zeros(size(pop,1),M);
    for i = 1:M
        score(:,i) = (rank(i)/sum(rank)).*numpop(:,i)+(1-rank(i)/sum(rank))*(0.5-numpop(:,i)).^3;
    end
    distributeScore = sum(score,2);
    if length(unique(distributeScore)) ~= 1
        distributeScore = (distributeScore-min(distributeScore))./(max(distributeScore)-min(distributeScore));  
    end
    
    aaa = numpop(ceil(distributeScore(1)+1));
    



end