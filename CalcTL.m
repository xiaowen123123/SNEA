function TL = CalcTL(GLA,pop,L)
%CALCTL 此处显示有关此函数的摘要
%   计算图拉普拉斯的迹，代表当前选择波段对原有波段结构信息的保留性质
pn = size(pop,1);
TL = zeros(pn,1);
for pmn = 1:pn
    X = GLA(:,pop(pmn,:));
%     TL(pmn) = trace(X'*L*X)./size(X,2);
    TL(pmn) = trace(X'*L*X);
end
end