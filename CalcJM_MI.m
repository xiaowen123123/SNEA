function JM_MI = CalcJM_MI(data,label,pop,MIall)
    pn = size(pop,1);
    JM_MI = zeros(pn,1);
    
    
    
    
    MIall = MIall+MIall';
%     class = unique(label);
%     classnum = length(class);
%     x = size(data);
%     Mv = zeros(classnum,x(2));
%     Cov = zeros(x(2),x(2),classnum);
%     pv = zeros(classnum,1);
%     for i = 1:classnum
%         index = label == class(i);
%         Mv(i,:) = mean(data(index,:));
%         Cov(:,:,i) = cov(data(index,:),'omitrows');
%         pv(i) = sum(index)/x(1);
%     end
%     BD = zeros(classnum,classnum);
%     JM = zeros(classnum,classnum);
%     PP = pv*pv';




    for m = 1:pn

        X = pop(m,:);
        ns = sum(X);
        %计算互信�?
%         MI = sum(MIall(X, X), 'all') / (ns*(ns-1));
        MI = sum(sum(MIall(X, X))) / (ns*(ns-1));
        
        
%         %计算JM distance
%         for i = 1:classnum
%            for j = i+1:classnum
%                MM = Mv(i,X)-Mv(j,X);
%                CC = (Cov(X,X,i)+Cov(X,X,j))/2;
%                pinv(CC);
%                part1 = (MM)*pinv(CC)*(MM)';
%                
%                part2 = log(det(CC)/sqrt(det(Cov(X,X,i))*det(Cov(X,X,j))));
%                if ~isreal(part2)
%                    part2 = 0;
%                end
%                BD(i,j) = (1/8)*part1+0.5*part2;
%                JM(i,j) = sqrt(2*(1-exp(-1*BD(i,j))));
%            end    
%         end
%         JM(isnan(JM)) = 0;
%         JMdistance = sum(PP.*JM,'all');



        JM_MI(m,1) = MI;
    end
end



