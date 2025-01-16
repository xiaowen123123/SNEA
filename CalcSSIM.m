function SSIMall = CalcSSIM(data)
        ns = size(data,2);
        SSIMall = zeros(ns);
        for i = 1:ns-1
            for j = i+1:ns  
                SSIMall(i,j) = SSIMCalc(data(:,i),data(:,j));
                clc;
                disp(['计算SSIM：',num2str(i),'/',num2str(j)]);
            end
        end
end

function SSIM = SSIMCalc(a, b)
    c1=(0.01*255)^2;
    c2=(0.03*255)^2;
    covab = cov(a,b);
    SSIM = (2*mean(a)*mean(b)+c1)*(2*covab(1,2)+c2)/(mean(a)^2+mean(b)^2+c1)*(cov(a)^2+cov(b)^2+c2);
end

