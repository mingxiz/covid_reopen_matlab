function vec = i_to_vec(i_index,n_age_strat,n_work_strat)

%  SEIR Model for COVID-19 reopenning project
%  Written for MATLAB_R2019b
%  Copyright (C) 2020
%     Mingxi Zhu <mingxiz@stanford.edu>

% utils for convenience
    table_index = zeros(n_age_strat,n_work_strat,2,8);
    start = 1;
    table_index_2 = cell(1,n_age_strat*n_work_strat*2*8);
    for i_epi = 1:8
        for i_p = 1:2
            for i_work = 1:n_work_strat
                for i_age = 1:n_age_strat
                    table_index(i_age,i_work,i_p,i_epi)= start;
                    table_index_2{start} = [i_age,i_work,i_p, i_epi];
                    start = start + 1;
                end
            end
        end
    end
    
    vec = table_index_2{i_index};
