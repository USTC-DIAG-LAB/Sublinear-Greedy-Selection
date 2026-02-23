function [k_center_idx, i] = k_center_alg2(data, epsilon, eta, r0, k0)
    num_data = size(data, 1);  % the number of data points
    init_center_idx = randi(num_data);  % initially, randomly select a point
    k_center_idx = init_center_idx;
    
    t = 0;
    i = 0;
%     disp(['t = ', num2str(t), ', i = ', num2str(i)]);
    
    while 1
        eta0 = eta / power(2, 2*t) / k0;
        S_size = round(12 / eta0 / epsilon * log(2/eta0));
        if S_size > num_data
            S_size = num_data;
        end
        S_idx = randperm(num_data, S_size);
        dist_mat_S = pdist2(data(S_idx,:), data(k_center_idx,:));
        
        repeat = power(2, t) * k0;
        Q_size = round(power(2,2*t) * 2 * k0 / epsilon * log(power(2,2*t)*k0/2/eta));
        if Q_size > num_data
            Q_size = num_data;
        end
%         disp(['S_size = ', num2str(S_size), ', Q_size = ', num2str(Q_size)]);
        for j = 1:repeat            
            Q_idx = randperm(num_data, Q_size);
            dist_mat_Q = pdist2(data(Q_idx,:), data(k_center_idx,:));
            dist_mat_Q = min(dist_mat_Q, [], 2);
            [~, farthest_idx_in_Q_idx] = max(dist_mat_Q);
            farthest_idx = Q_idx(farthest_idx_in_Q_idx);
            k_center_idx = [k_center_idx; farthest_idx];
            
            i = i + 1;
%             disp(['t = ', num2str(t), ', i = ', num2str(i)]);            
            
            tmp_dist_mat = pdist2(data(S_idx,:), data(farthest_idx,:));
            dist_mat_S = min([dist_mat_S, tmp_dist_mat], [], 2);
            tau = sum(dist_mat_S > r0) / S_size;
            if tau <= 3*epsilon/2
                return;
            end
        end
        
        t = t + 1;
    end
end
