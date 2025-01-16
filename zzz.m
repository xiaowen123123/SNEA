% clc;clear;close all;
% % A = randi(10,2,3);
% % cov(A)
% rand(1)
% count=0;
% for i=1:100000    
%     fprintf(repmat('\b',1,count));   
%     count=fprintf('current line is : %d',i);
% %     pause(0.0005);
% end

% 最后要换行，不然光标在刚才一行的行末，影响后面的输出操作
% 
% fprintf('\n');
% 
% tempf = 65;
% a = min(tempf,2);
% figure(1)
% hold on;
% for i = 1:5
%     y = 600-100*i;
%     x = 0.2*i;
%     bar(x,y,0.03+0.02*i)
% end
% axis([0 1.2 0 600]);

% clc;clear;
% index = 0;
% index = gpuArray(index);
% tic
% for i = 1 : 100000
% 
%     for j = 1 : 100000
%         index = index + 1;
%     end
% 
% end
% toc
% A = [0,0];
% B = [0,1;5,5;1,0];
% x = [A(1);B(:,1)];
% y = [A(2);B(:,2)];
% figure(1)
% scatter(x,y);
% hold on;
% p1 = A;
% p2 = B(2,:);
% plot(p1,p2);
% q1 = B(1,:);
% q2 = B(3,:);
% ans = iscro(p1,p2,q1,q2);
% ans1 = iscro(q1,q2,p1,p2);
% if ans<0 && ans1<0
%     
%     disp("相交");
% end
% function ans = iscro(P1,P2,Q1,Q2)   %判断两线段是否相交
% P1Q1 = Q1 - P1; P1P2 = P2 - P1; P1Q2 = Q2 - P1;
% P1Q1(:,3) = 0; P1P2(:,3) = 0; P1Q2(:,3) = 0;
% a1 = cross(P1Q1,P1P2);a2 = cross(P1Q2,P1P2);
% ans = dot(a1,a2);
% end

%             x = finresult(4:end,2);
%             y = finresult(4:end,1);
%             figure(1);
%             hold on;
%             plot(x,y,'-o');
%             xlabel('featureN');
%             ylabel('acc');             
%             set(gca,'YTick',[0.45:0.05:0.9]);%设置要显示坐标刻度
%             title('fold');
%             legend;
% clc;clear;
%                log = fopen('log.txt','a');
%                fprintf(log,"MYVarMI:使用方差和互信息进行计算，算子使用第一部分算子\n\n");
%                fclose(log);
% A = [4 -7 3; 1 4 -2; 10 7 9];
% var(A)
% figure(1);
% hold on;
% for i = 1:57
%     
%    bandDist(KNNfinpop(i,:)); 
%     
% end
% tic
% i = zeros(10000,1);
% for j = 1:100000000
%     i(j) = 1;
% end
% toc;
clc;clear;
a = rand(3);
a(1,:) = [1,2,3];
a(2,:) = [2,2,2];
% a = ones(3);
c = cov(a)
d = cov(a')
cd = det(c)
dd = det(d)
