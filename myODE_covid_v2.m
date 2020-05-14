function dy = myODE_covid_v2(t, y, n_param, param_epi, parm_beta, parm_policy, x0)

% in v2, the model didn't encorporate the change on Nj0 for dieout rate

    n_age_strat =  n_param.n_age_strat;
    n_work_strat = n_param.n_work_strat;
    dy = ones(n_age_strat*n_work_strat*2*8,1);
    
    k_det = param_epi.k_det;
    delta = param_epi.delta;
    alpha_i = param_epi.alpha_i;
    k_rep_i = param_epi.k_rep_i;
    r_I = param_epi.r_I;
    r_A = param_epi.r_A;
    gamma = param_epi.gamma;
    m_i = param_epi.m_i;
    e = parm_policy.e;
    


    for i0 = 1: n_age_strat
        for i1 = 1: n_work_strat
            
            %flow of S0_t - >  x_state(i0, i1, 1, 1, t);   
            flow_nopolicy_sym = 0;
            flow_nopolicy_asym = 0;
            flow_policy_sym = 0;
            flow_policy_asym = 0;
            for j0 = 1: n_age_strat
                for j1 = 1: n_work_strat
                     Nj0 = y(vec_to_i([i0,i1,1,1],n_param))+y(vec_to_i([i0,i1,1,2],n_param))+y(vec_to_i([i0,i1,1,3],n_param))+y(vec_to_i([i0,i1,1,4],n_param))+y(vec_to_i([i0,i1,1,5],n_param))+y(vec_to_i([i0,i1,1,6],n_param))+y(vec_to_i([i0,i1,1,7],n_param));
                     Nj1 = y(vec_to_i([i0,i1,2,1],n_param))+y(vec_to_i([i0,i1,2,2],n_param))+y(vec_to_i([i0,i1,2,3],n_param))+y(vec_to_i([i0,i1,2,4],n_param))+y(vec_to_i([i0,i1,2,5],n_param))+y(vec_to_i([i0,i1,2,6],n_param))+y(vec_to_i([i0,i1,2,7],n_param));
                    % UI-indexed by 3, DI indexed by 4
                    % UA-indexed by 5, DA indexed by 6 
                    flow_nopolicy_sym = flow_nopolicy_sym - parm_beta(1,1,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 1, 1],n_param))*(y(vec_to_i([j0,j1,1,3],n_param))+k_det*y(vec_to_i([j0,j1,1,4],n_param)))/Nj0;
                    flow_nopolicy_asym = flow_nopolicy_asym - parm_beta(1,2,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 1, 1],n_param))*(y(vec_to_i([j0,j1,1,5],n_param))+k_det*y(vec_to_i([j0,j1,1,6],n_param)))/Nj0;
                    flow_policy_sym = flow_policy_sym - e*parm_beta(2,1,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 1, 1],n_param))*(y(vec_to_i([j0,j1,2,3],n_param))+k_det*y(vec_to_i([j0,j1,2,4],n_param)))/Nj1;
                    flow_policy_asym = flow_policy_asym - e*parm_beta(2,2,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 1, 1],n_param))*(y(vec_to_i([j0,j1,2,5],n_param))+k_det*y(vec_to_i([j0,j1,2,6],n_param)))/Nj1;
                end
            end
            dy(vec_to_i([i0, i1, 1, 1],n_param)) =   flow_nopolicy_sym + flow_nopolicy_asym + flow_policy_sym + flow_policy_asym;
            
            %flow of E0_t -> x_state(i0, i1, 1, 2, t)
            dy(vec_to_i([i0, i1, 1, 2],n_param)) = - flow_nopolicy_sym - flow_nopolicy_asym - flow_policy_sym - flow_policy_asym - delta*y(vec_to_i([i0, i1, 1, 2],n_param));
                 
            %flow of S1_t - >  x_state(i0, i1, 2, 1, t);
            flow_nopolicy_sym = 0;
            flow_nopolicy_asym = 0;
            flow_policy_sym = 0;
            flow_policy_asym = 0;
            for j0 = 1: n_age_strat
                for j1 = 1: n_work_strat
                    Nj0 = y(vec_to_i([i0,i1,1,1],n_param))+y(vec_to_i([i0,i1,1,2],n_param))+y(vec_to_i([i0,i1,1,3],n_param))+y(vec_to_i([i0,i1,1,4],n_param))+y(vec_to_i([i0,i1,1,5],n_param))+y(vec_to_i([i0,i1,1,6],n_param))+y(vec_to_i([i0,i1,1,7],n_param));
                    Nj1 = y(vec_to_i([i0,i1,2,1],n_param))+y(vec_to_i([i0,i1,2,2],n_param))+y(vec_to_i([i0,i1,2,3],n_param))+y(vec_to_i([i0,i1,2,4],n_param))+y(vec_to_i([i0,i1,2,5],n_param))+y(vec_to_i([i0,i1,2,6],n_param))+y(vec_to_i([i0,i1,2,7],n_param));
                    % UI-indexed by 3, DI indexed by 4
                    % UA-indexed by 5, DA indexed by 6 
                    flow_nopolicy_sym = flow_nopolicy_sym - parm_beta(1,1,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 2, 1],n_param))*(y(vec_to_i([j0,j1,1,3],n_param))+k_det*y(vec_to_i([j0,j1,1,4],n_param)))/Nj0;
                    flow_nopolicy_asym = flow_nopolicy_asym - parm_beta(1,2,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 2, 1],n_param))*(y(vec_to_i([j0,j1,1,5],n_param))+k_det*y(vec_to_i([j0,j1,1,6],n_param)))/Nj0;
                    flow_policy_sym = flow_policy_sym - e*parm_beta(2,1,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 2, 1],n_param))*(y(vec_to_i([j0,j1,2,3],n_param))+k_det*y(vec_to_i([j0,j1,2,4],n_param)))/Nj1;
                    flow_policy_asym = flow_policy_asym - e*parm_beta(2,2,i0,i1,j0,j1)*y(vec_to_i([i0, i1, 2, 1],n_param))*(y(vec_to_i([j0,j1,2,5],n_param))+k_det*y(vec_to_i([j0,j1,2,6],n_param)))/Nj1;
                end
            end
            dy(vec_to_i([i0, i1, 2, 1],n_param)) = flow_nopolicy_sym + flow_nopolicy_asym + flow_policy_sym + flow_policy_asym;
            
            %flow of E1_t -> x_state(i0, i1, 2, 2, t)
            dy(vec_to_i([i0, i1, 2, 2],n_param)) = - flow_nopolicy_sym - flow_nopolicy_asym - flow_policy_sym - flow_policy_asym - delta*y(vec_to_i([i0, i1, 2, 2],n_param));
            
            %flow of UI0_t ->  x_state(i0, i1, 1, 3, t);
            dy(vec_to_i([i0, i1, 1, 3],n_param)) = (1-alpha_i(i0,i1))*delta*y(vec_to_i([i0, i1, 1, 2],n_param)) - (k_rep_i(i0, i1)*r_I+gamma)*y(vec_to_i([i0, i1, 1, 3],n_param));
            
            %flow of UI1_t ->  x_state(i0, i1, 2, 3, t);
            dy(vec_to_i([i0, i1, 2, 3],n_param)) = (1-alpha_i(i0,i1))*delta*y(vec_to_i([i0, i1, 2, 2],n_param)) - (k_rep_i(i0, i1)*r_I+gamma)*y(vec_to_i([i0, i1, 2, 3],n_param));
            
            %flow of DI0_t ->  x_state(i0, i1, 1, 4, t);
            dy(vec_to_i([i0, i1, 1, 4],n_param)) = k_rep_i(i0, i1)*r_I*y(vec_to_i([i0, i1, 1, 3],n_param)) - gamma*y(vec_to_i([i0, i1, 1, 4],n_param));
            
            %flow of DI1_t ->  x_state(i0, i1, 2, 4, t);
            dy(vec_to_i([i0, i1, 2, 4],n_param)) = k_rep_i(i0, i1)*r_I*y(vec_to_i([i0, i1, 2, 3],n_param)) - gamma*y(vec_to_i([i0, i1, 2, 4],n_param));
            
            %flow of UA0_t ->  x_state(i0, i1, 1, 5, t);
            dy(vec_to_i([i0, i1, 1, 5],n_param)) = alpha_i(i0,i1)*delta*y(vec_to_i([i0, i1, 1, 2],n_param)) - (k_rep_i(i0, i1)*r_A+gamma)*y(vec_to_i([i0, i1, 1, 5],n_param));
            
            %flow of UA1_t ->  x_state(i0, i1, 1, 5, t);
            dy(vec_to_i([i0, i1, 2, 5],n_param)) = alpha_i(i0,i1)*delta*y(vec_to_i([i0, i1, 2, 2],n_param)) - (k_rep_i(i0, i1)*r_A+gamma)*y(vec_to_i([i0, i1, 2, 5],n_param));
             
            %flow of DA0_t ->  x_state(i0, i1, 1, 6, t);
            dy(vec_to_i([i0, i1, 1, 6],n_param)) = k_rep_i(i0, i1)*r_A*y(vec_to_i([i0, i1, 1, 5],n_param)) - gamma*y(vec_to_i([i0, i1, 1, 6],n_param));
            
            %flow of DA1_t ->  x_state(i0, i1, 2, 6, t);
            dy(vec_to_i([i0, i1, 2, 6],n_param)) = k_rep_i(i0, i1)*r_A*y(vec_to_i([i0, i1, 2, 5],n_param)) - gamma*y(vec_to_i([i0, i1, 2, 6],n_param));
            
            %flow of R0_t ->  x_state(i0, i1, 1, 7, t);
            dy(vec_to_i([i0, i1, 1, 7],n_param)) = (1-m_i(i0,i1))*gamma*(y(vec_to_i([i0, i1, 1, 3],n_param)) + y(vec_to_i([i0, i1, 1, 4],n_param))) + gamma*(y(vec_to_i([i0, i1, 1, 5],n_param)) + y(vec_to_i([i0, i1, 1, 6],n_param)));
            
            %flow of R1_t ->  x_state(i0, i1, 2, 7, t);
            dy(vec_to_i([i0, i1, 2, 7],n_param)) = (1-m_i(i0,i1))*gamma*(y(vec_to_i([i0, i1, 2, 3],n_param)) + y(vec_to_i([i0, i1, 2, 4],n_param))) + gamma*(y(vec_to_i([i0, i1, 2, 5],n_param)) + y(vec_to_i([i0, i1, 2, 6],n_param)));
            
            %flow of D0_t ->  x_state(i0, i1, 1, 8, t);
            dy(vec_to_i([i0, i1, 1, 8],n_param)) = m_i(i0,i1)*gamma*(y(vec_to_i([i0, i1, 1, 3],n_param)) + y(vec_to_i([i0, i1, 1, 4],n_param)));

            %flow of D1_t ->  x_state(i0, i1, 2, 8, t);
            dy(vec_to_i([i0, i1, 2, 8],n_param)) = m_i(i0,i1)*gamma*(y(vec_to_i([i0, i1, 2, 3],n_param)) + y(vec_to_i([i0, i1, 2, 4],n_param)));
        end
    end