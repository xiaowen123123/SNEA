function Fitness = CalcFitness(pop,Results_segment,K,mS,m,nK)
%CALCFITNESS 此处显示有关此函数的摘要
%   此处显示详细说明
pn = size(pop,1);
Fitness = zeros(size(pop,1),1);
for t = 1:pn
    for i = 1:K
       S = cell2mat(Results_segment.Y(1,i));
       S = S(randperm(size(S,1),floor(size(S,1)/10)),:);
       Sbsp = nK(i)*(mS(i,pop(t,:)))*(mS(i,pop(t,:)))';
       Stsp = sum((S(:,pop(t,:))-m(pop(t,:)))*(S(:,pop(t,:))-m(pop(t,:)))');
    end
    SBSP = trace(sum(Sbsp));
    STSP = trace(sum(Stsp));
    Fitness(t) = -SBSP/STSP;
%     Fitness(t) = -STSP;
end
end

