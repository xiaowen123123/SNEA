function superPixInclass = CalcSuperpInclass(pop,Results_segment,K)
%CALCSUPERPINCLASS �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
pn = size(pop,1);
superPixInclass = zeros(size(pop,1),1);
for t = 1:pn
    preSuperPixInclass = 0;
    for i = 1:K
       S = cell2mat(Results_segment.Y(1,i));
%        A = S(randperm(size(S,1),10),pop(t,:));
        A = S(:,pop(t,:));
       preSuperPixInclass = preSuperPixInclass+mean(var(A));
    end
    superPixInclass(t) = preSuperPixInclass;
end
end

