function k_center_idx = k_center_streaming(data, k, mu, eps_hat)
    % initialization
    num_data = size(data, 1);
    tau = mu * k;
    T = zeros(tau+1, 1);
    phi = Inf;
    for i = 1:tau+1
        T(i,:) = i;
        if i > 1
            dist = pdist2(data(i,:), data(T(1:i-1,:),:));
            min_dist = min(dist);
            if min_dist < phi
                phi = min_dist;
            end
        end
    end
    phi = phi / 2;
    weight = ones(tau+1, 1);
    
    % streaming
    for i = tau+2:num_data
        while size(T,1) > tau
            merge();
        end
        dist = pdist2(data(i,:), data(T,:));
        [min_dist, min_idx] = min(dist);
        if min_dist <= 2 * phi
            weight(min_idx,:) = weight(min_idx,:) + 1;
        else
            T = [T; i];
            weight = [weight; 1];
        end
    end

%     dist = pdist(data(T,:));
%     dist_l = min(dist);
%     dist_r = max(dist);
%     delta = eps_hat / (3+4*eps_hat);
%     r_values = zeros(ceil(log(dist_r/dist_l)/log(1+delta))+1, 1);
%     r_values(1,:) = dist_l;
%     for i = 2:size(r_values,1)
%         r_values(i,:) = r_values(i-1,:) * (1+delta);
%     end
%     left_idx = 1;
%     right_idx = size(r_values,1);

    r_values = pdist(data(T,:));
    r_values = sort(r_values);
    left_idx = 1;
    right_idx = size(r_values, 2);
    k_center_idx = [];
    while left_idx <= right_idx
        mid = floor((left_idx + right_idx) / 2);
        [T_prime, X] = outliers_cluster(r_values(:,mid));
        if size(T_prime, 1) == 0
            k_center_idx = X;
            right_idx = mid - 1;
        else
            left_idx = mid + 1;
        end
    end
    
    
    function merge()
        discard = zeros(tau+1, 1);
        phi = 1.5 * phi;
        dist_T = squareform(pdist(data(T,:)));
        for ii = 1:tau
            if discard(ii,:) == 1
                continue;
            end
            for jj = ii+1:tau+1
                if discard(jj,:) == 1
                    continue;
                end
                if dist_T(ii,jj) <= 1.25*phi
                    discard(jj,:) = 1;  % discard j
                    weight(ii,:) = weight(ii,:) + weight(jj,:);
                end
            end
        end
        T(discard==1,:) = [];
        weight(discard==1,:) = [];
    end


    function [T_prime, X] = outliers_cluster(r)
        T_prime = T;
        w = weight;
        num_T = size(T,1);
        w_temp = zeros(num_T, 1);
        X = [];
        while size(X,1)<k && size(T_prime,1)~=0
            % calculate the distances between points in T and T'
            dist_temp = pdist2(data(T,:), data(T_prime,:));
            for iii = 1:num_T
                % find the points that can be (1+2*eps_hat)*r covered
                % by T[iii]
                condition = dist_temp(iii,:)<=(1+2*eps_hat)*r;
                % calculate the weight for T[iii]
                w_temp(iii,:) = sum(w(condition,:));
            end
            % select the point with maximum weight
            [~, max_idx] = max(w_temp);
            X = [X; T(max_idx,:)];
            % calculate the distances between T[max_idx] and points in T'
            dist_temp = pdist2(data(T(max_idx,:),:), data(T_prime,:));
            % find the points that can be (3+4*eps_hat)*r covered
            % by T[max_idx]
            condition = dist_temp <= (1+4*eps_hat)*r;
            % remove these points from T' and w
            T_prime(condition,:) = [];
            w(condition,:) = [];
        end
    end
end