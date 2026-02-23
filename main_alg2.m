% r0_cifar10 = [5250, 5300, 5350, 5400, 5450, 5500, 5550, 5600];
% r0_mnist = [2420, 2445, 2470, 2495, 2520, 2545, 2570, 2595];

save_folder = strcat('./exp_res/alg2/', dataset_);
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
    disp(['current r0 : ', num2str(r0)]);
    save_filename_greedy = strcat(save_folder, '/r0_',...
        num2str(r0), '_greedy.mat');
    runtime_greedy = zeros(repeat, 1);
    radius_greedy = zeros(repeat, 1);
    k_greedy = zeros(repeat, 1);
    for rep = 1:repeat
        disp(['K-Center greedy, rep ', num2str(rep), ' begins.']);
        tic
        k_center_greedy_res = k_center_greedy_nok(data, r0);
        runtime_greedy(rep, :) = toc;
        k_greedy(rep, :) = size(k_center_greedy_res, 1);
        disp(['K-Center greedy, rep ', num2str(rep), ' ends.']);
        dist_mat = pdist2(data, data(k_center_greedy_res,:));
        radius_greedy(rep, :) = max(min(dist_mat, [], 2));
        k_center_idx_greedy{rep, 1} = k_center_greedy_res;
        disp(['Number of centers: ', num2str(size(k_center_greedy_res, 1))]);
    end
    save(save_filename_greedy, 'k_center_idx_greedy', 'k_greedy',...
        'runtime_greedy', 'radius_greedy');
    disp([save_filename_greedy, ' saved.']);
% randomized
elseif strcmp(alg, "randomized")
    disp("Using randomized");
    save_filename_randomized = strcat(save_folder,...
        '/r0_', num2str(r0), '_randomized_eps_', num2str(epsilon),...
        '_eta_', num2str(eta), '_k0_', num2str(k0), '.mat');
    runtime_randomized = zeros(repeat, 1);
    radius_randomized = zeros(repeat, 1);
    k_randomized = zeros(repeat, 1);
    for rep = 1:repeat
        disp(['epsilon = ', num2str(epsilon), ', eta = ',...
            num2str(eta), ', k0 = ', num2str(k0)]);
        disp(['current r0 : ', num2str(r0)]);
        disp(['K-Center randomized, rep ', num2str(rep), ' begins.']);
        tic
        [k_center_randomized_res, i_ter] = k_center_alg2(data, epsilon, eta, r0, k0);
        runtime_randomized(rep, :) = toc;
        k_randomized(rep, :) = size(k_center_randomized_res, 1);
        disp(['K-Center randomized, rep ', num2str(rep), ' ends.']);
        dist_mat = pdist2(data, data(k_center_randomized_res,:));
        radius_randomized(rep, :) = max(min(dist_mat, [], 2));
        k_center_idx_randomized{rep, 1} = k_center_randomized_res;
        disp(['Number of centers: ', num2str(size(k_center_randomized_res, 1))]);
    end
    save(save_filename_randomized, 'k_center_idx_randomized',...
        'k_randomized', 'runtime_randomized', 'radius_randomized');
    disp([save_filename_randomized, ' saved.']);       
end
