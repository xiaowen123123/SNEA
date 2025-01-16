function MIall = CalcMI(data)
        ns = size(data,2);
        MIall = zeros(ns);
        for i = 1:ns-1
            for j = i+1:ns  
                MIall(i,j) = MICalc(data(:,i),data(:,j));
                clc;
                disp(['计算MI：',num2str(i),'/',num2str(j)]);
            end
        end
end
%计算两列向量之间的互信息
%u1：输入计算的向量1
%u2：输入计算的向量2
%wind_size：向量的维度
% function mi = calc_mi(u1, u2, wind_size)
% x = [u1, u2];
% n = wind_size;
% [xrow, xcol] = size(x);
% bin = zeros(xrow,xcol);
% pmf = zeros(n, 2);
% for i = 1:2
%     minx = min(x(:,i));
%     maxx = max(x(:,i));
%     binwidth = (maxx - minx) / n;
%     edges = minx + binwidth*(0:n);
%     histcEdges = [-Inf edges(2:end-1) Inf];
%     [occur,bin(:,i)] = histc(x(:,i),histcEdges,1); %通过直方图方式计算单个向量的直方图分布
%     pmf(:,i) = occur(1:n)./xrow;
% end
% %计算u1和u2的联合概率密度
% jointOccur = accumarray(bin,1,[n,n]);  %（xi，yi）两个数据同时落入n*n等分方格中的数量即为联合概率密度
% jointPmf = jointOccur./xrow;
% Hx = -(pmf(:,1))'*log2(pmf(:,1)+eps);
% Hy = -(pmf(:,2))'*log2(pmf(:,2)+eps);
% Hxy = -(jointPmf(:))'*log2(jointPmf(:)+eps);
% MI = Hx+Hy-Hxy;
% mi = MI/sqrt(Hx*Hy);
% end

function MI = MICalc(a, b)
    %Caculate MI of a and b in the region of the overlap part
    %计算重叠部分
    [M,N]=size(a);
    %初始化直方图数组
    hab = zeros(256,256);
    %归一化
    %统计直方图
    for i=1:M
        for j=1:N
            indexx = a(i,j);
            indexy = b(i,j) ;
            hab(indexx,indexy) = hab(indexx,indexy)+1;%联合直方图
        end
    end
    %计算联合信息熵
    hsum = sum(sum(hab));
    index = find(hab~=0);
    p = hab/hsum;
    Hab = sum(-p(index).*log(p(index)));
    %计算a图信息熵
    Ha = entropy(a);
    %计算b图信息熵
    Hb = entropy(b);
    %计算a和b的互信息（越大匹配结果越好）
    MI = Ha+Hb-Hab;

end

