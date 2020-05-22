function parm_beta = generate_param_beta3(n_age_strat, n_work_strat, param_epi,W_multiplier, O_multiplier, S_multiplier, H_multipler,fvpvnvRatioVec, epi_ymo_fvpvnv_fullTWTOTS, phaseIndicator)

%here need table be on same dictionary
    v_table_nopolicy =  getCM3(W_multiplier, O_multiplier, S_multiplier, H_multipler, fvpvnvRatioVec, epi_ymo_fvpvnv_fullTWTOTS, phaseIndicator);

    v_table_policy = v_table_nopolicy;
    
    parm_beta = covid_open_beta(n_age_strat, n_work_strat, v_table_nopolicy, v_table_policy, param_epi);
    
    
