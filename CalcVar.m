function Var = CalcVar(data,pop)
    pn =size(pop,1);
    Var = zeros(pn,1);
    for m = 1:pn
        X = pop(m,:);
        ns = sum(X);
        while ns == 0
           index = randi(size(pop,2),5,1);
           X(1,index) = true;
           ns = sum(X);
        end
        v = var(data(:,X));
        Var(m) = mean(v);
    end
end