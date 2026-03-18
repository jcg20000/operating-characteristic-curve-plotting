%% OC curve for USP <905> using Monte Carlo

clear
rng(1)

Nsim = 100000;

mu = 100;          % target
k = 2.4;           % USP constant

n_batch = 150;     % large-N characterization
n_test = 10;       % USP sample size

sigma_values = 2:0.25:8;   % process variability range

pass_prob = zeros(size(sigma_values));

for i = 1:length(sigma_values)

    sigma = sigma_values(i);
    pass = 0;

    for j = 1:Nsim

        % Step 1: generate batch of size 150
        batch = mu + sigma*randn(n_batch,1);

        % Step 2: simulate USP sampling (10 units)
        sample = batch(randperm(n_batch, n_test));

        xbar = mean(sample);
        s = std(sample);

        M = 100;

        AV = abs(M - xbar) + k*s;

        if AV <= 15
            pass = pass + 1;
        end

    end

    pass_prob(i) = pass / Nsim;

end

%% Plot OC curve
figure
plot(sigma_values, pass_prob, 'LineWidth', 2)
xlabel('Process Standard Deviation (\sigma)')
ylabel('Probability of Passing USP <905>')
title('OC Curve for USP <905> (n_{batch}=150)')
grid on