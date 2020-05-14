function x0 = covid_open_x0(n_age_strat,n_work_strat, age_dist, work_dist, epi_dist, total_N)
    
    % at beginiing 0 people under policy
    policy_pct = 0
    x0 = zeros(n_age_strat, n_work_strat, 2, 8);
    % 2 indicates whether it's in policy (0, 1)
    % 8 SEIR [S E UI DI UA DA R D]);
    
    % construct x0
    % all people at S at x0
    for i_age = 1:n_age_strat
        for i = 1: 8
            x0(i_age,:,1,i) =  epi_dist(i_age,i)*total_N*(1-policy_pct)*age_dist(i_age)'*work_dist;
            x0(i_age,:,2,i) =  epi_dist(i_age,i)*total_N*policy_pct*age_dist(i_age)'*work_dist;
        end
    end
    
    x0 = round(x0);