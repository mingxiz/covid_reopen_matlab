function parm_beta = generate_param_beta(n_age_strat, n_work_strat, param_epi, table_name)

%here need table be on same dictionary
    T = readtable(table_name,'Range','AA1:AI37');
    V_temp = table2array(T);
    V = zeros(size(V_temp, 2),size(V_temp,2), 4);
    for i = 1: 4
        V(:,:,i)=V_temp((i-1)*size(V,2)+1:i*size(V,2),:);
    end
    v_table_nopolicy = sum(V,3);
    
    % v_table_nopolicy(:,3) = 0.2*v_table_nopolicy(:,3);
    % v_table_nopolicy = 0.8*v_table_nopolicy;


    v_table_policy = v_table_nopolicy;
    
    parm_beta = covid_open_beta(n_age_strat, n_work_strat, v_table_nopolicy, v_table_policy, param_epi);
    
    
