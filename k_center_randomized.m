function k_center_idx = k_center_randomized(data, k, epsilon, eta)
    n_prime = round(k / epsilon * log(k/eta));  % n' in the paper
    num_data = size(data, 1);  % the number of data points
    k_center_idx = zeros(k, 1);  % the index of k centers
    init_center_idx = randi(num_data);  % initially, randomly select a point
    k_center_idx(1) = init_center_idx;
    % iteratively select the next center
    for i = 2:k
        Qj_idx = randperm(num_data, n_prime);  % Qj in the paper
        tmp_dist_mat = pdist2(data(Qj_idx,:), data(k_center_idx(1:i-1), :));
        dist_mat = min(tmp_dist_mat, [], 2);
        [~, farthest_idx_in_Qj_idx] = max(dist_mat);
        farthest_idx = Qj_idx(farthest_idx_in_Qj_idx);
        k_center_idx(i) = farthest_idx;
        if i == k
            break
        end
    end
end
