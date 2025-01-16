function testfigure(finresult,objs,choice)
    switch choice
        case 1
            x = finresult(:,2);%特征数
            y = finresult(:,1);%分类精度
            z = finresult(:,3);%Kappa系数
            figure(4);
%             subplot(1,2,1);
            plot(x,y,'-o');
            xlabel('FN');
            ylabel('Acc'); 
%             axis ([min(finresult(:,2)) max(finresult(:,2)) 0.5 0.75] );
            title('ACC');
%             subplot(1,2,2);
            figure(5);
            plot(x,z,'-o');
            xlabel('FN');
            ylabel('Kappa');   
%             axis ([min(finresult(:,2)) max(finresult(:,2)) 0.4 0.75] );
            title('Kappa');
            
        case 2
            figure(2);
            x = objs(:,1);
            y = objs(:,2);
            plot(x,y,'o');
            xlabel('f1:Var');
            ylabel('f2:MI');
            title('Objs');
        case 3
    end
end