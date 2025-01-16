function [objVar,objMI,objnear,objInclass,objTL,objFitness] = Calcobjs(grayValue,fulllabel,pop,MIall,nearpoints,MS,Results_segment,GLA,L,mS,m,nK)
        objVar = -CalcVar(grayValue,pop);    
        objTL  = CalcTL(GLA,pop,L)+objVar;
        objMI = zeros(size(pop,1),1);
        objnear = Calcnear(grayValue,nearpoints,pop,MS);
        objInclass = 0;
        objFitness = CalcFitness(pop,Results_segment,500,mS,m,nK)+objnear;
        objnear = 0;
end