function y0 = get_y_from_x(n_age_strat,n_work_strat,x0_p)

% construct vector on y0 from x0_p
start = 1;
y0 = zeros(8*2*n_age_strat*n_work_strat, 1);
for i_epi = 1:8
    for i_p = 1:2
        for i_work = 1:n_work_strat
            for i_age = 1:n_age_strat
                y0(start,1)=x0_p(i_age,i_work,i_p,i_epi);
                start = start + 1;
            end
        end
    end
end