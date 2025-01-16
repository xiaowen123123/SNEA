function [distributeScore,distribute] = CalDS_new(pop,entrop,T)
    entrop = (entrop-min(entrop))/(max(entrop)-min(entrop));
    M = length(unique(T));
    numpop = zeros(size(pop,1),M);
    numpopN = zeros(size(pop,1),M);
    for i = 1:M
        left = find(T == i,1,'first');
        right = find(T == i,1,'last');
        numpopN(:,i) = sum(pop(:,left:right),2)>0.5;
        numpop(:,i) = (1-sum(pop(:,left:right),2)/(right-left+1));
        numScore(:,left:right) = repmat(numpop(:,i),1,right-left+1);
    end
    distribute = sum(numpopN,2)./M;
    mindata = min(numScore,[],2);
    maxdata = max(numScore,[],2);
    numScore = (numScore-mindata)./(maxdata-mindata);
    entropScore = repmat(entrop,size(pop,1),1);
    distributeScore = numScore.*entropScore;
    mindata = min(distributeScore,[],2);
    maxdata = max(distributeScore,[],2);
    distributeScore = (distributeScore-mindata)./(maxdata-mindata);
end