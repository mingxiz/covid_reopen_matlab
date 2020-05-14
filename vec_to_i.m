function index_i = vec_to_i(vec_i,n_param)

n_work_strat = n_param.n_work_strat;
n_age_strat = n_param.n_age_strat;

    table_index = zeros(n_age_strat,n_work_strat,2,8);
    start = 1;
    for i_epi = 1:8
        for i_p = 1:2
            for i_work = 1:n_work_strat
                for i_age = 1:n_age_strat
                    table_index(i_age,i_work,i_p,i_epi)= start;
                    start = start + 1;
                end
            end
        end
    end
    age_index = vec_i(1);
    work_index = vec_i(2);
    policy_index = vec_i(3);
    epi_index = vec_i(4);

    index_i = table_index(age_index,work_index,policy_index,epi_index);
