function bandDist(pop)
%BANDDIST �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
x = size(pop);
if(x(1)==1)
x = find(pop == 1);
y = repmat(sum(pop),1,sum(pop));
scatter(x,y);
else
    hold off
    for i = 1:x(1)
        x = find(pop(i,:) == 1);
        y = repmat(2*i,1,sum(pop(i,:)));
        scatter(x,y);
        hold on;
    end
end
end

