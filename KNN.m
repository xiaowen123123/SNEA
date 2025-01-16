function fit = KNN(data, label, X)
% LOOCV
% KNN, k = 1

    X = X > 0.6;

    if sum(X) == 0
        fit = [1, size(data, 2)];
        return;
    end
    data = data(:, X);
    % dist = pdist2(data, data, 'cityblock');
    dist = pdist2(data, data);
    [~, idx] = min(dist + eye(size(data, 1)) * max(max(dist) * 2), [], 2);
    y = label(idx);
    y = y == label;
    acc = sum(y) / numel(y);
    err = 1 - acc;
    fit = [err, sum(X)];

end