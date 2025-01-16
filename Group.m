function T = Group(traindata,gNum)
    x = size(traindata);
%     initT = zeros(x(2),1);
    %均匀划分
%     for i = 1:gNum
%         if i == gNum
%             initT(i*x(2)/gNum:end,1) = i;
%         else
%             initT((i-1)*x(2)/gNum+1:i*(x(2)/gNum),1) = i;
%         end
%     end
    %近邻聚类划分
    %初始化聚类中心
    P = ceil((1:gNum)*x(2)/gNum-x(2)/2/gNum);
    R = inf(1,x(2));
    T = zeros(1,x(2));

    for m = 1:gNum
        if m ==1
            Xj = traindata(:,1:P(m+1)-1);
            Xp = traindata(:,P(m));
            D = pdist2(Xj',Xp');
            for j = 1:size(Xj,2)
                if D(j)<R(j)
                    R(j) = D(j);
                    T(j) = m;
                end
            end
        elseif m == gNum
            Xj = traindata(:,P(m-1)+1:end);
            Xp = traindata(:,P(m));
            D = pdist2(Xj',Xp');
            for j = 1:size(Xj,2)
                if D(j)<R(P(m-1)+j)
                    R(P(m-1)+j) = D(j);
                    T(P(m-1)+j) = m;
                end
            end
        else
            Xj = traindata(:,P(m-1)+1:P(m+1)-1);
            Xp = traindata(:,P(m));
            D = pdist2(Xj',Xp');
            for j = 1:size(Xj,2)
                if D(j)<R(P(m-1)+j)
                    R(P(m-1)+j) = D(j);
                    T(P(m-1)+j) = m;
                end
            end
        end
    end
    %处理噪音
    for m = 1:gNum-1
        left = find(T == m, 1, 'last' );
        right = find(T == m+1,1,'first');
        if left > right
            if pdist2(traindata(:,P(m))',traindata(:,right:left)')>pdist2(traindata(:,P(m+1))',traindata(:,right:left)')
                T(right:left) = m;
            else
                T(right:left) = m+1;
            end
        end 
    end
end

    