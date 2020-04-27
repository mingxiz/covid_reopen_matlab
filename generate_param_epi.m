function param_epi = generate_param_epi(n_age_strat, n_work_strat)

    param_epi.kappa = 0.375;
    param_epi.p = 0.05;
    % Relative susceptibility of individuals in age group i
    param_epi.ksi = ones(n_age_strat, n_work_strat);
    % Relative infectiousness of individuals in age group j 
    param_epi.kij = ones(n_age_strat, n_work_strat);
    % Relative contact reduction for infected individuals 0.5
    param_epi.k_det = 0.5;
    %1/delta: Average length of the incubation period
    param_epi.delta = 1/5;
    % Proportion of cases in age group i that do not go on to experience symptoms
    param_epi.alpha_i = repmat([0.75, 0.3, 0.3]',1,3);
    % Relative detection rate for individuals in age group i 
    param_epi.k_rep_i = ones(n_age_strat,n_work_strat);
    % Detection rate for symptomatic infections
    param_epi.r_I = 0.1;
    % Detection rate for asymptomatic infections
    param_epi.r_A = 0.01;
    % Average duration of infection to recovery or death 5 days
    param_epi.gamma = 1/5;
    % Mortality risk for group i 
    param_epi.m_i = repmat([0, 0.01, 0.1]',1,3);