function JM_MI = CalcJM_MI(data,label,pop,MIall)
    pn = size(pop,1);
    JM_MI = zeros(pn,1);
    MIall = MIall+MIall';
    for m = 1:pn
        X = pop(m,:);
        ns = sum(X);
        MI = sum(sum(MIall(X, X))) / (ns*(ns-1));        
        JM_MI(m,1) = MI;
    end
end



