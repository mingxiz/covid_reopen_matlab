function sol = covid_reopen_policy(x0, T_end, n_age_strat, n_work_strat, param_epi, parm_beta, param_policy)

% x0 = zeros(n_age_strat, n_work_strat, 2[1-nopolicy,2-policy], 8[S E UI DI UA DA R D]);
% beta = ones(length(id_p), length(id_a), n_age_strat, n_work_strat, n_age_strat, n_work_strat);
% id_a = 1 symptomatic, id_a = 2 asymptomatic;
% id_p = 1 no policy, id_p = 2 policy
k_det = param_epi.k_det;
delta = param_epi.delta;
alpha_i = param_epi.alpha_i;
k_rep_i = param_epi.k_rep_i;
r_I = param_epi.r_I;
r_A = param_epi.r_A;
gamma = param_epi.gamma;
m_i = param_epi.m_i;
e = param_policy.e;


%flow of evolve without policy
x_state = zeros(n_age_strat,n_work_strat,2,8,length(1:T_end)+1);
x_state(:,:,:,:,1) = x0;

for t = 2:T_end+1
    %flow of S0
    for i0 = 1: n_age_strat
        for i1 = 1: n_work_strat
            
            %flow of S0_t - >  x_state(i0, i1, 1, 1, t);   
            flow_nopolicy_sym = 0;
            flow_nopolicy_asym = 0;
            flow_policy_sym = 0;
            flow_policy_asym = 0;
            for j0 = 1: n_age_strat
                for j1 = 1: n_work_strat
                    Nj0 = sum(x_state(j0,j1,1,:,t-1));
                    Nj1 = sum(x_state(j0,j1,2,:,t-1));
                    % UI-indexed by 3, DI indexed by 4
                    % UA-indexed by 5, DA indexed by 6 
                    flow_nopolicy_sym = flow_nopolicy_sym - parm_beta(1,1,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,1,3,t-1)+k_det*x_state(j0,j1,1,4,t-1))/Nj0;
                    flow_nopolicy_asym = flow_nopolicy_asym - parm_beta(1,2,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,1,5,t-1)+k_det*x_state(j0,j1,1,6,t-1))/Nj0;
                    flow_policy_sym = flow_policy_sym - e*parm_beta(2,1,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,2,3,t-1)+k_det*x_state(j0,j1,2,4,t-1))/Nj1;
                    flow_policy_asym = flow_policy_asym - e*parm_beta(2,2,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,2,5,t-1)+k_det*x_state(j0,j1,2,6,t-1))/Nj1;
                end
            end
            x_state(i0, i1, 1, 1, t) = x_state(i0, i1, 1, 1, t-1) + flow_nopolicy_sym + flow_nopolicy_asym + flow_policy_sym + flow_policy_asym;
            
            %flow of S1_t - >  x_state(i0, i1, 2, 1, t);
            flow_nopolicy_sym = 0;
            flow_nopolicy_asym = 0;
            flow_policy_sym = 0;
            flow_policy_asym = 0;
            for j0 = 1: n_age_strat
                for j1 = 1: n_work_strat
                    Nj0 = sum(x_state(j0,j1,1,:,t-1));
                    Nj1 = sum(x_state(j0,j1,2,:,t-1));
                    % UI-indexed by 3, DI indexed by 4
                    % UA-indexed by 5, DA indexed by 6 
                    flow_nopolicy_sym = flow_nopolicy_sym - parm_beta(1,1,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,1,3,t-1)+k_det*x_state(j0,j1,1,4,t-1))/Nj0;
                    flow_nopolicy_asym = flow_nopolicy_asym - parm_beta(1,2,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,1,5,t-1)+k_det*x_state(j0,j1,1,6,t-1))/Nj0;
                    flow_policy_sym = flow_policy_sym - e*parm_beta(2,1,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,2,3,t-1)+k_det*x_state(j0,j1,2,4,t-1))/Nj1;
                    flow_policy_asym = flow_policy_asym - e*parm_beta(2,2,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,2,5,t-1)+k_det*x_state(j0,j1,2,6,t-1))/Nj1;
                end
            end
            x_state(i0, i1, 2, 1, t) = x_state(i0, i1, 2, 1, t-1) + flow_nopolicy_sym + flow_nopolicy_asym + flow_policy_sym + flow_policy_asym;
            
            %flow of E0_t -> x_state(i0, i1, 1, 2, t)
            flow_nopolicy_sym = 0;
            flow_nopolicy_asym = 0;
            flow_policy_sym = 0;
            flow_policy_asym = 0;
            for j0 = 1: n_age_strat
                for j1 = 1: n_work_strat
                    Nj0 = sum(x_state(j0,j1,1,:,t-1));
                    Nj1 = sum(x_state(j0,j1,2,:,t-1));
                    % UI-indexed by 3, DI indexed by 4
                    % UA-indexed by 5, DA indexed by 6 
                    flow_nopolicy_sym = flow_nopolicy_sym + parm_beta(1,1,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,1,3,t-1)+k_det*x_state(j0,j1,1,4,t-1))/Nj0;
                    flow_nopolicy_asym = flow_nopolicy_asym + parm_beta(1,2,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,1,5,t-1)+k_det*x_state(j0,j1,1,6,t-1))/Nj0;
                    flow_policy_sym = flow_policy_sym + e*parm_beta(2,1,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,2,3,t-1)+k_det*x_state(j0,j1,2,4,t-1))/Nj1;
                    flow_policy_asym = flow_policy_asym + e*parm_beta(2,2,i0,i1,j0,j1)*x_state(i0, i1, 1, 1,t-1)*(x_state(j0,j1,2,5,t-1)+k_det*x_state(j0,j1,2,6,t-1))/Nj1;
                end
            end
            x_state(i0, i1, 1, 2, t) = x_state(i0, i1, 1, 2, t-1) + flow_nopolicy_sym + flow_nopolicy_asym + flow_policy_sym + flow_policy_asym - delta*x_state(i0, i1, 1, 2, t-1);
                        
            %flow of E1_t - >  x_state(i0, i1, 2, 2, t);
            flow_nopolicy_sym = 0;
            flow_nopolicy_asym = 0;
            flow_policy_sym = 0;
            flow_policy_asym = 0;
            for j0 = 1: n_age_strat
                for j1 = 1: n_work_strat
                    Nj0 = sum(x_state(j0,j1,1,:,t-1));
                    Nj1 = sum(x_state(j0,j1,2,:,t-1));
                    % UI-indexed by 3, DI indexed by 4
                    % UA-indexed by 5, DA indexed by 6 
                    flow_nopolicy_sym = flow_nopolicy_sym + parm_beta(1,1,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,1,3,t-1)+k_det*x_state(j0,j1,1,4,t-1))/Nj0;
                    flow_nopolicy_asym = flow_nopolicy_asym + parm_beta(1,2,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,1,5,t-1)+k_det*x_state(j0,j1,1,6,t-1))/Nj0;
                    flow_policy_sym = flow_policy_sym + e*parm_beta(2,1,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,2,3,t-1)+k_det*x_state(j0,j1,2,4,t-1))/Nj1;
                    flow_policy_asym = flow_policy_asym + e*parm_beta(2,2,i0,i1,j0,j1)*x_state(i0, i1, 2, 1,t-1)*(x_state(j0,j1,2,5,t-1)+k_det*x_state(j0,j1,2,6,t-1))/Nj1;
                end
            end
            x_state(i0, i1, 2, 2, t) = x_state(i0, i1, 2, 1, t-1) + flow_nopolicy_sym + flow_nopolicy_asym + flow_policy_sym + flow_policy_asym - delta*x_state(i0, i1, 2, 2, t-1);
            
            %flow of UI0_t ->  x_state(i0, i1, 1, 3, t);
            x_state(i0, i1, 1, 3, t) = x_state(i0, i1, 1, 3, t-1) + (1-alpha_i(i0,i1))*delta*x_state(i0, i1, 1, 2, t-1) - (k_rep_i(i0, i1)*r_I+gamma)*x_state(i0, i1, 1, 3, t-1);
            
            %flow of UI1_t ->  x_state(i0, i1, 2, 3, t);
            x_state(i0, i1, 2, 3, t) = x_state(i0, i1, 2, 3, t-1) + (1-alpha_i(i0,i1))*delta*x_state(i0, i1, 2, 2, t-1) - (k_rep_i(i0, i1)*r_I+gamma)*x_state(i0, i1, 2, 3, t-1);
            
            %flow of DI0_t ->  x_state(i0, i1, 1, 4, t);
            x_state(i0, i1, 1, 4, t) = x_state(i0, i1, 1, 4, t-1) + k_rep_i(i0, i1)*r_I*x_state(i0, i1, 1, 3, t-1) - gamma*x_state(i0, i1, 1, 4, t-1);
            
            %flow of DI1_t ->  x_state(i0, i1, 2, 4, t);
            x_state(i0, i1, 2, 4, t) = x_state(i0, i1, 2, 4, t-1) + k_rep_i(i0, i1)*r_I*x_state(i0, i1, 2, 3, t-1) - gamma*x_state(i0, i1, 2, 4, t-1);
            
            %flow of UA0_t ->  x_state(i0, i1, 1, 5, t);
            x_state(i0, i1, 1, 5, t) = x_state(i0, i1, 1, 5, t-1) + alpha_i(i0,i1)*delta*x_state(i0, i1, 1, 2, t-1) - (k_rep_i(i0, i1)*r_A+gamma)*x_state(i0, i1, 1, 5, t-1);
            
            %flow of UA1_t ->  x_state(i0, i1, 1, 5, t);
            x_state(i0, i1, 2, 5, t) = x_state(i0, i1, 2, 5, t-1) + alpha_i(i0,i1)*delta*x_state(i0, i1, 2, 2, t-1) - (k_rep_i(i0, i1)*r_A+gamma)*x_state(i0, i1, 2, 5, t-1);
             
            %flow of DA0_t ->  x_state(i0, i1, 1, 6, t);
            x_state(i0, i1, 1, 6, t) = x_state(i0, i1, 1, 6, t-1) + k_rep_i(i0, i1)*r_A*x_state(i0, i1, 1, 5, t-1) - gamma*x_state(i0, i1, 1, 6, t-1);
            
            %flow of DA1_t ->  x_state(i0, i1, 2, 6, t);
            x_state(i0, i1, 2, 6, t) = x_state(i0, i1, 2, 6, t-1) + k_rep_i(i0, i1)*r_A*x_state(i0, i1, 2, 5, t-1) - gamma*x_state(i0, i1, 2, 6, t-1);
            
            %flow of R0_t ->  x_state(i0, i1, 1, 7, t);
            x_state(i0, i1, 1, 7, t) = x_state(i0, i1, 1, 7, t-1) + (1-m_i(i0,i1))*gamma*(x_state(i0, i1, 1, 3, t-1) + x_state(i0, i1, 1, 4, t-1)) + gamma*(x_state(i0, i1, 1, 5, t-1) + x_state(i0, i1, 1, 6, t-1));
            
            %flow of R1_t ->  x_state(i0, i1, 2, 7, t);
            x_state(i0, i1, 2, 7, t) = x_state(i0, i1, 2, 7, t-1) + (1-m_i(i0,i1))*gamma*(x_state(i0, i1, 2, 3, t-1) + x_state(i0, i1, 2, 4, t-1)) + gamma*(x_state(i0, i1, 2, 5, t-1) + x_state(i0, i1, 2, 6, t-1));
            
            %flow of D0_t ->  x_state(i0, i1, 1, 8, t);
            x_state(i0, i1, 1, 8, t) = x_state(i0, i1, 1, 8, t-1) + m_i(i0,i1)*gamma*(x_state(i0, i1, 1, 3, t-1) + x_state(i0, i1, 1, 4, t-1));

            %flow of D1_t ->  x_state(i0, i1, 2, 8, t);
            x_state(i0, i1, 2, 8, t) = x_state(i0, i1, 2, 8, t-1) + m_i(i0,i1)*gamma*(x_state(i0, i1, 2, 3, t-1) + x_state(i0, i1, 2, 4, t-1));
        end
    end
end


sol.x_state = x_state;