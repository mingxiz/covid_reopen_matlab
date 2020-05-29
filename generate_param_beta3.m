function parm_beta = generate_param_beta3(n_age_strat, n_work_strat, param_epi,W_multiplier, O_multiplier, S_multiplier, H_multipler,fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare)

%here need table be on same dictionary

    epi_ymo_fvpvnv_TWTOTS = getHrs(fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare);
    
    v_table_nopolicy =  getCM(W_multiplier, O_multiplier, S_multiplier, H_multipler, epi_ymo_fvpvnv_TWTOTS);

    v_table_policy = v_table_nopolicy;
    
    parm_beta = covid_open_beta(n_age_strat, n_work_strat, v_table_nopolicy, v_table_policy, param_epi);
    
    
