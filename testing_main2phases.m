close all 
W_multiplier =  0.7;
O_multiplier = 1;
S_multiplier = 1;
H_multiplier = 0.5;

t_SIP = 50;
t_reopen = 110;
t_end = 130;
N_zero_patient = 4;

W_multiplier_r = W_multiplier;
O_multiplier_r = O_multiplier;
S_multiplier_r = 1;
H_multipler_r = H_multiplier;

infect_rate = 0.03;
options_figure = 1;

fv_TWratio = 1
pv_TWratio = 1
nv_TWratio = 1
TOratio = 1
TSratio = 1
o_specialCare = 1

output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)