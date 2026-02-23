function k_center_idx = k_center_uniform(data, k, ratio)
    num_data = size(data, 1);
    rand_idx = randperm(num_data);
    num_points = round(num_data * ratio);
    rand_idx = rand_idx(1:num_points);
    tmp_center_points = data(rand_idx, :);
    
    if k == num_points
        k_center_idx = rand_idx';
    else
        tmp_center_idx = zeros(k, 1);  % the index of k centers
        init_center_idx = randi(num_points);
        tmp_center_idx(1) = init_center_idx;
        % the distance between the initial center and other points
        dist_mat = pdist2(tmp_center_points, tmp_center_points(init_center_idx,:));
        % iteratively select the next center
        for i = 2:k
            % select the point farthest from the selected centers
            [~, nxt_center_idx] = max(dist_mat);
            tmp_center_idx(i) = nxt_center_idx;
            if i == k
                break
            end
            % the distance between the new center and other points
            tmp_dist_mat = pdist2(tmp_center_points, tmp_center_points(nxt_center_idx,:));
            % the distance between the selected centers and other points
            dist_mat = min([dist_mat,tmp_dist_mat], [], 2);
        end
        k_center_idx = rand_idx(tmp_center_idx)';
    end
end