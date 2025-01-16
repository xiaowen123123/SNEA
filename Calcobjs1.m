function [obj1,obj2] = Calcobjs1(grayValue,fulllabel,pop,MIall,SSIMall,nearpoints,MS,Results_segment,GLA,L,Lnear,entrop)
        objTL  = CalcTL(GLA,pop,Lnear); 
        objnear = Calcnear(grayValue,nearpoints,pop,MS);
        obj1 = objTL;
        obj2 = objnear;
end