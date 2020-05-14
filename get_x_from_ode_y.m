function  x = get_x_from_ode_y(sol,n_age_strat,n_work_strat)
x = zeros(n_age_strat,n_work_strat,2,8,size(sol.x,2));
yt = sol.y;
start = 1;
for i_epi = 1:8
    for i_p = 1:2
        for i_work = 1:n_work_strat
            for i_age = 1:n_age_strat
                for i_t = 1:size(sol.x,2)
                    x(i_age,i_work,i_p,i_epi,i_t)=yt(start,i_t);
                end
                start = start+1;
            end
        end
    end
end