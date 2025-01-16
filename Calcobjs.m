function [objVar,objMI,objnear,objInclass,objTL,objFitness] = Calcobjs(grayValue,fulllabel,pop,MIall,nearpoints,MS,Results_segment,GLA,L,mS,m,nK)
        objVar = -CalcVar(grayValue,pop);    
%         objVar = sum(pop,2);
        objTL  = CalcTL(GLA,pop,L)+objVar;
%         objTL  = 0;
%         objVar = rand(size(pop,1),1);
%         objMI = CalcJM_MI(grayValue,fulllabel,pop,MIall);
        objMI = zeros(size(pop,1),1);
        objnear = Calcnear(grayValue,nearpoints,pop,MS);
%         objInclass = CalcSuperpInclass(pop,Results_segment,300);
        objInclass = 0;
        objFitness = CalcFitness(pop,Results_segment,500,mS,m,nK)+objnear;
        objnear = 0;
end