save_folder = strcat('./exp_res/alg1/', dataset_, '/k');
if exist(save_folder, 'dir') == 0
    mkdir(save_folder)
end

if strcmp(dataset_, "cifar10")
    disp("Loading cifar10");
    load('./datasets/CIFAR10/cifar10_data.mat');
    num_data = size(data, 1);
    rand_idx = randperm(num_data);
    data = data(rand_idx, :);
    disp("Finish loading cifar10");
elseif strcmp(dataset_, "mnist")
    disp("Loading mnist");
    load('./datasets/MNIST/mnist_data.mat');
    num_data = size(data, 1);
    rand_idx = randperm(num_data);
    data = data(rand_idx, :);
    disp("Finish loading mnist");
end

% greedy
if strcmp(alg, "greedy")
    disp("Using greedy");
    for k = k_min:k_interval:k_max
        disp(['k = ', num2str(k)]);
        save_filename_greedy = strcat(save_folder, '/k_',...
            num2str(k), '_greedy.mat');
        runtime_greedy = zeros(repeat, 1);
        radius_greedy = zeros(repeat, 1);
        k_center_idx_greedy = zeros(repeat, k, 1);
        for rep = 1:repeat
            disp(['K-Center greedy, rep ', num2str(rep), ' begins.']);
            tic
            k_center_greedy_res = k_center_greedy(data, k);
            runtime_greedy(rep, :) = toc;
            disp(['K-Center greedy, rep ', num2str(rep), ' ends.']);
            dist_mat = pdist2(data, data(k_center_greedy_res,:));
            radius_greedy(rep, :) = max(min(dist_mat, [], 2));
            k_center_idx_greedy(rep, :, :) = k_center_greedy_res;
        end
        save(save_filename_greedy, 'k_center_idx_greedy', 'runtime_greedy', 'radius_greedy');
        disp([save_filename_greedy, ' saved.']);
    end
% randomized
elseif strcmp(alg, "randomized")
    disp("Using randomized");
    disp(['epsilon = ', num2str(epsilon), ', eta = ', num2str(eta)]);
    for k = k_min:k_interval:k_max
        disp(['k = ', num2str(k)]);
        save_filename_randomized = strcat(save_folder,...
            '/k_', num2str(k), '_randomized_eps_', num2str(epsilon),...
            '_eta_', num2str(eta), '.mat');
        runtime_randomized = zeros(repeat, 1);
        radius_randomized = zeros(repeat, 1);
        k_center_idx_randomized = zeros(repeat, k, 1);
        for rep = 1:repeat
            disp(['K-Center randomized, rep ', num2str(rep), ' begins.']);
            tic
            k_center_randomized_res = k_center_randomized(data, k, epsilon, eta);
            runtime_randomized(rep, :) = toc;
            disp(['K-Center randomized, rep ', num2str(rep), ' ends.']);
            dist_mat = pdist2(data, data(k_center_randomized_res,:));
            radius_randomized(rep, :) = max(min(dist_mat, [], 2));
            k_center_idx_randomized(rep, :, :) = k_center_randomized_res;
        end
        save(save_filename_randomized, 'k_center_idx_randomized', 'runtime_randomized', 'radius_randomized');
        disp([save_filename_randomized, ' saved.']);
    end
elseif strcmp(alg, "uniform")
    disp("Using uniform");
    disp(['ratio = ', num2str(ratio)]);
    for k = k_min:k_interval:k_max
        disp(['k = ', num2str(k)]);
        save_filename_uniform = strcat(save_folder, '/k_', num2str(k),...
            '_uniform_ratio_', num2str(ratio), '.mat');
        runtime_uniform = zeros(repeat, 1);
        radius_uniform = zeros(repeat, 1);
        k_center_idx_uniform = zeros(repeat, k, 1);
        for rep = 1:repeat
            disp(['K-Center uniform, rep ', num2str(rep), ' begins.']);
            tic
            k_center_uniform_res = k_center_uniform(data, k, ratio);
            runtime_uniform(rep, :) = toc;
            disp(['K-Center uniform, rep ', num2str(rep), ' ends.']);
            dist_mat = pdist2(data, data(k_center_uniform_res,:));
            radius_uniform(rep, :) = max(min(dist_mat, [], 2));
            k_center_idx_uniform(rep, :, :) = k_center_uniform_res;
        end
        save(save_filename_uniform, 'k_center_idx_uniform', 'runtime_uniform', 'radius_uniform');
        disp([save_filename_uniform, ' saved.']);
    end
elseif strcmp(alg, "streaming")
    disp("Using streaming");
    disp(['eps_hat = ', num2str(eps_hat), ', mu = ', num2str(mu)]);
    for k = k_min:k_interval:k_max
        disp(['k = ', num2str(k)]);
        save_filename_streaming = strcat(save_folder, '/k_',...
            num2str(k), '_streaming_epshat_', num2str(eps_hat),...
            '_mu_', num2str(mu), '.mat');
        runtime_streaming = zeros(repeat, 1);
        radius_streaming = zeros(repeat, 1);
        for rep = 1:repeat
            disp(['K-Center streaming, rep ', num2str(rep), ' begins.']);
            rand_idx = randperm(num_data);
            data = data(rand_idx, :);
            rand_idx = randperm(num_data);
            data = data(rand_idx, :);
            tic
            k_center_streaming_res = k_center_streaming(data, k, mu, eps_hat);
            runtime_streaming(rep, :) = toc;
            disp(['K-Center streaming, rep ', num2str(rep), ' ends.']);
            dist_mat = pdist2(data, data(k_center_streaming_res,:));
            radius_streaming(rep, :) = max(min(dist_mat, [], 2));
            k_center_idx_streaming{rep, 1} = k_center_streaming_res;
        end
        save(save_filename_streaming, 'k_center_idx_streaming', 'runtime_streaming', 'radius_streaming');
        disp([save_filename_streaming, ' saved.']);
    end
end
