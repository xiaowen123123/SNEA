function near = Calcnear(~,~,pop,MS)
    x = size(MS);
    pn =size(pop,1);
    near = zeros(pn,1);
    %% 使用预算好的平方差计算距离
    for pnm = 1:pn
        Tnear = zeros(ceil(x(1)),8);
       for  i = 1:8
          Tnear(:,i) = sqrt(sum(MS(:,pop(pnm,:),i),2)./sum(pop(pnm,:)));
       end
       near(pnm) = mean(mean(Tnear,2));
    end
end