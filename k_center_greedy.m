function k_center_idx = k_center_greedy(data, k)
    num_data = size(data, 1);  % the number of data points
    k_center_idx = zeros(k, 1);  % the index of k centers
    init_center_idx = randi(num_data);  % initially, randomly select a point
    k_center_idx(1) = init_center_idx;
    % the distance between the initial center and other points
    dist_mat = pdist2(data, data(init_center_idx,:));
    % iteratively select the next center
    for i = 2:k
        % select the point farthest from the selected centers
        [~, nxt_center_idx] = max(dist_mat);
        k_center_idx(i) = nxt_center_idx;
        if i == k
            break
        end
        % the distance between the new center and other points
        tmp_dist_mat = pdist2(data, data(nxt_center_idx,:));
        % the distance between the selected centers and other points
        dist_mat = min([dist_mat,tmp_dist_mat], [], 2);
    end
end
