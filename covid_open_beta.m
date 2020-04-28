function parm_beta = covid_open_beta(n_age_strat,n_work_strat, v_table_nopolicy, v_table_policy, param_epi)

%  SEIR Model for COVID-19 reopenning project
%  Written for MATLAB_R2019b
%  Copyright (C) 2020
%     Mingxi Zhu <mingxiz@stanford.edu>

    % feed in table with v_table_policy, nopolicy
    %policy e could depedent on age_strat and work_strat, e is of size zeros(n_age_strat,n_work_strat,n_age_strat,n_work_strat)
    id_p = [1, 2];
    % id_p = 1 no policy, id_p = 2 policy
    id_a = [1, 2];
    % id_a = 1 symptomatic, id_a = 2 asymptomatic;
    
    parm_beta = ones(length(id_p), length(id_a), n_age_strat, n_work_strat, n_age_strat, n_work_strat);
    % param_epi.kappa

    
    % v_table_nopolicy (n_age_strat*n_work_strat)*(n_age_strat*n_work_strat)
    % age - (y m o)
    % work - (f p n)
    % v_table_policy (n_age_strat*n_work_strat)*(n_age_strat*n_work_strat)
    
    kappa = param_epi.kappa;
    ksi = param_epi.ksi;
    kij = param_epi.kij;
    p = param_epi.p;
    
    for int_i0 = 1: n_age_strat
        for int_i1 = 1: n_work_strat
            for int_j0 = 1: n_age_strat
                 for int_j1 = 1: n_work_strat
                     % baseline, no policy, symptomatic/ asymptomatic
                     % import data from vij
                     parm_beta(1, 1, int_i0, int_i1, int_j0, int_j1) = v_table_nopolicy((int_i0-1)*n_work_strat+int_i1,(int_j0-1)*n_work_strat+int_j1)*p*ksi(int_i0, int_i1)*kij(int_j0, int_j1);
                     parm_beta(1, 2, int_i0, int_i1, int_j0, int_j1) = kappa*parm_beta(1, 1, int_i0, int_i1, int_j0, int_j1);
                     parm_beta(2, 1, int_i0, int_i1, int_j0, int_j1) = v_table_policy((int_i0-1)*n_work_strat+int_i1,(int_j0-1)*n_work_strat+int_j1)*p*ksi(int_i0,int_i1)*kij(int_j0,int_j1);
                     parm_beta(2, 2, int_i0, int_i1, int_j0, int_j1) = kappa*parm_beta(2, 1, int_i0, int_i1, int_j0, int_j1);
                 end
            end
        end
    end
