W_multiplier = 1;
O_multiplier = 0.3;
S_multiplier = 0;
H_multiplier = 0.6;

t_SIP = 50;
t_reopen = 110;
t_end = 400;
N_zero_patient = 10;

W_multiplier_r = 1;
O_multiplier_r = 1;
S_multiplier_r = 1;
H_multipler_r = 0.8;

infect_rate = 0.028;
options_figure = 1;

fvpvnvRatioVec = [0 0 0.5]
fvpvnvRatioVec_r = [0 0.5 1]
epi_ymo_fvpvnv_fullTWTOTS_r =  [1.22
4.466
0.77
2.21
2.16
2.65
5.06
0.432
0.03
2.52
2.94
3.555]
output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier,W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fvpvnvRatioVec, fvpvnvRatioVec_r, epi_ymo_fvpvnv_fullTWTOTS_r, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)
