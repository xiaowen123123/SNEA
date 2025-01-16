function [obj1,obj2] = Calcobjs1(grayValue,fulllabel,pop,MIall,SSIMall,nearpoints,MS,Results_segment,GLA,L,Lnear,entrop)
        


%         objVar = CalcVar(grayValue,pop);  
%         objVar = (objVar-min(objVar))/(max(objVar)-min(objVar));
%         objEntrop = CalcEntrop(entrop,pop);
%         objEntrop = (objEntrop-min(objEntrop))/(max(objEntrop)-min(objEntrop));
        objTL  = CalcTL(GLA,pop,Lnear); 
%         objTL = (objTL-min(objTL))/(max(objTL)-min(objTL));
%         objMI = CalcJM_MI(grayValue,fulllabel,pop,MIall);
%         objMI = (objMI-min(objMI))/(max(objMI)-min(objMI));
%         objSSIM = CalcPSSIM(grayValue,fulllabel,pop,MIall);
        objnear = Calcnear(grayValue,nearpoints,pop,MS);
%         objnear = (objnear-min(objnear))/(max(objnear)-min(objnear));
%         objInclass = CalcSuperpInclass(pop,Results_segment,300);
        obj1 = objTL;
        obj2 = objnear;
end