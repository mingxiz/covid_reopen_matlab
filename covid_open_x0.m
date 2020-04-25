function x0 = covid_open_x0(n_age_strat,n_work_strat, age_dist, work_dist, epi_dist, policy_pct, total_N)

    x0 = zeros(n_age_strat, n_work_strat, 2, 8);
    % 2 indicates whether it's in policy (0, 1)
    % 8 SEIR [S E UI DI UA DA R D]);
    
    % construct x0
    % all people at S at x0
    for i = 1: 8
        x0(:,:,1,i) =  epi_dist(i)*total_N*(1-policy_pct)*age_dist'*work_dist;
        x0(:,:,2,i) =  epi_dist(i)*total_N*policy_pct*age_dist'*work_dist;
    end
    
    x0 = round(x0);