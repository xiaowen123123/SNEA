function TL = CalcTL(GLA,pop,L)
%CALCTL �˴���ʾ�йش˺�����ժҪ
%   ����ͼ������˹�ļ�������ǰѡ�񲨶ζ�ԭ�в��νṹ��Ϣ�ı�������
pn = size(pop,1);
TL = zeros(pn,1);
for pmn = 1:pn
    X = GLA(:,pop(pmn,:));
%     TL(pmn) = trace(X'*L*X)./size(X,2);
    TL(pmn) = trace(X'*L*X);
end
end