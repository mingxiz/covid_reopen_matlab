% run model

function x = covid_run_model(x0, T_p_start, T_p_length, n_age_strat, n_work_strat, param_epi, parm_beta, param_policy)

    sol_no_policy = covid_reopen_nopolicy(x0, T_p_start, n_age_strat, n_work_strat, param_epi, parm_beta);
    x_crt_nopolicy = sol_no_policy.x_state;
    
    policy_pct = param_policy.policy_pct;
    
    %create x_crt_no_policy under policy percentage
    x_crt_nopolicy_p = zeros(size(x_crt_nopolicy));
    for t = 1:size(x_crt_nopolicy, 5)
        for i_epi = 1:8
            for i_age = 1: n_age_strat
                for i_work = 1 : n_work_strat
                    x_crt_nopolicy_p(i_age,i_work,1,i_epi,t)=(1-policy_pct(i_age,i_work))*x_crt_nopolicy(i_age,i_work,1,i_epi,t);
                    x_crt_nopolicy_p(i_age,i_work,2,i_epi,t)=(policy_pct(i_age,i_work))*x_crt_nopolicy(i_age,i_work,1,i_epi,t);
                end
            end
        end
    end
            
    x0_crt = x_crt_nopolicy_p(:,:,:,:,size(x_crt_nopolicy, 5));
    
    sol_policy = covid_reopen_policy(x0_crt, T_p_length, n_age_strat, n_work_strat, param_epi, parm_beta, param_policy);
    x_crt_policy = sol_policy.x_state;

    dim = size(x_crt_policy);
    dim(5) = size(x_crt_nopolicy,5)+size(x_crt_policy,5)-1;
    x = zeros(dim);
    x(:,:,:,:,1:T_p_start) = x_crt_nopolicy_p(:,:,:,:,1:T_p_start);
    x(:,:,:,:,T_p_start+1:end) = x_crt_policy;
