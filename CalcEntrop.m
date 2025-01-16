function entrop = CalcEntrop(data,pop)
        pn = size(pop,1);
        entrop = zeros(pn,1);
        for i = 1:pn
            entrop(i) = mean(data(pop(i,:)));
        end
end