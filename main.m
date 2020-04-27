% main
% input parameters
% [y m o] % [fv pv nv]
n_age_strat = 3; n_work_strat = 3; total_N = 100000;
%following paper
age_dist = [0.25, 0.59, 0.16]; work_dist = [0.309 0.3455 0.3455];
%initial epi dist on S E UI DI UA DA R D
epi_dist = [7 0.2 0.2 0.2 0.2 0.2 0 0]; epi_dist = epi_dist./sum(epi_dist);
% calculate intial state
x0 = covid_open_x0(n_age_strat, n_work_strat, age_dist, work_dist, epi_dist, total_N);

% generate epi parameters besides beta
param_epi = generate_param_epi(n_age_strat, n_work_strat);

% generate beta
parm_beta = generate_param_beta(n_age_strat, n_work_strat, param_epi);

% generate param policy
param_policy = generate_param_policy;


% Run model: input T_p_start, T_p_length
% policy starts at day 25
T_p_start = 25;
% policy lasts for 30 days
T_p_length = 30;
x = covid_run_model(x0, T_p_start, T_p_length, n_age_strat, n_work_strat, param_epi, parm_beta, param_policy);


