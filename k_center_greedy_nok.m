function k_center_idx = k_center_greedy_nok(data, r0)
    num_data = size(data, 1);  % the number of data points
    init_center_idx = randi(num_data);  % initially, randomly select a point
    k_center_idx = init_center_idx;
    % the distance between the initial center and other points
    dist_mat = pdist2(data, data(init_center_idx,:));
    % iteratively select the next center
%     cnt = 0;
    while 1
        if max(dist_mat) <= r0
            return;
        end
%         cnt = cnt + 1;
%         disp(['cnt = ', num2str(cnt)]);
        % select the point farthest from the selected centers
        [~, nxt_center_idx] = max(dist_mat);
        k_center_idx = [k_center_idx; nxt_center_idx];
        % the distance between the new center and other points
        tmp_dist_mat = pdist2(data, data(nxt_center_idx,:));
        % the distance between the selected centers and other points
        dist_mat = min([dist_mat,tmp_dist_mat], [], 2);
    end
end
