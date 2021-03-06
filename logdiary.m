%daily data 1
close all 
clear
clc
W_multiplier =  0.8;
O_multiplier = 0.8;
S_multiplier = 0.8;
H_multiplier = 0.5;

t_SIP = 50;
t_reopen = 140;
t_end = 500;
N_zero_patient = 4;

W_multiplier_r = W_multiplier;
O_multiplier_r = O_multiplier;
S_multiplier_r = S_multiplier;
H_multipler_r = H_multiplier;

infect_rate = 0.03;
options_figure = 1;

fv_TWratio = 0
pv_TWratio = 0
nv_TWratio = 1
TOratio = 0.5
TSratio = 0
o_specialCare = 1

output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)

n_age_strat = 3;
n_work_strat = 3;
daily_data = get_dynamic_data(output.x1, output.x2, output.x3, output.y1, output.y2, output.y3, n_age_strat,n_work_strat, t_SIP, t_reopen, t_end)


%daily data 2
close all 
clear
clc
W_multiplier =  0.8;
O_multiplier = 0.8;
S_multiplier = 0.8;
H_multiplier = 0.5;

t_SIP = 50;
t_reopen = 140;
t_end = 500;
N_zero_patient = 4;

W_multiplier_r = W_multiplier;
O_multiplier_r = O_multiplier;
S_multiplier_r = S_multiplier;
H_multipler_r = H_multiplier;

infect_rate = 0.03;
options_figure = 1;

fv_TWratio = 0
pv_TWratio = 0.5
nv_TWratio = 1
TOratio = 0.5
TSratio = 0.5
o_specialCare = 1

output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)

n_age_strat = 3;
n_work_strat = 3;
daily_data = get_dynamic_data(output.x1, output.x2, output.x3, output.y1, output.y2, output.y3, n_age_strat,n_work_strat, t_SIP, t_reopen, t_end)

%daily data 3
close all 
clear
clc
W_multiplier =  0.8;
O_multiplier = 0.8;
S_multiplier = 0.8;
H_multiplier = 0.5;

t_SIP = 50;
t_reopen = 140;
t_end = 500;
N_zero_patient = 4;

W_multiplier_r = W_multiplier;
O_multiplier_r = O_multiplier;
S_multiplier_r = S_multiplier;
H_multipler_r = H_multiplier;

infect_rate = 0.03;
options_figure = 1;

fv_TWratio = 0
pv_TWratio = 0.5
nv_TWratio = 1
TOratio = 0.805
TSratio = 0.5
o_specialCare = 1

output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)

n_age_strat = 3;
n_work_strat = 3;
daily_data = get_dynamic_data(output.x1, output.x2, output.x3, output.y1, output.y2, output.y3, n_age_strat,n_work_strat, t_SIP, t_reopen, t_end)


%daily data 4
close all 
clear
clc
W_multiplier =  0.8;
O_multiplier = 0.8;
S_multiplier = 0.8;
H_multiplier = 0.5;

t_SIP = 50;
t_reopen = 140;
t_end = 500;
N_zero_patient = 4;

W_multiplier_r = W_multiplier;
O_multiplier_r = O_multiplier;
S_multiplier_r = S_multiplier;
H_multipler_r = H_multiplier;

infect_rate = 0.03;
options_figure = 1;

fv_TWratio = 0
pv_TWratio = 0.5
nv_TWratio = 1
TOratio = 0.925
TSratio = 0.5
o_specialCare = 1

output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)

n_age_strat = 3;
n_work_strat = 3;
daily_data = get_dynamic_data(output.x1, output.x2, output.x3, output.y1, output.y2, output.y3, n_age_strat,n_work_strat, t_SIP, t_reopen, t_end)

%daily data  5
close all 
clear
clc
W_multiplier =  0.8;
O_multiplier = 0.8;
S_multiplier = 0.8;
H_multiplier = 0.5;

t_SIP = 50;
t_reopen = 140;
t_end = 500;
N_zero_patient = 4;

W_multiplier_r = W_multiplier;
O_multiplier_r = 1;
S_multiplier_r = S_multiplier;
H_multipler_r = H_multiplier;

infect_rate = 0.03;
options_figure = 1;

fv_TWratio = 0
pv_TWratio = 0.5
nv_TWratio = 1
TOratio = 0.6
TSratio = 0.5
o_specialCare = 1

output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)

n_age_strat = 3;
n_work_strat = 3;
daily_data = get_dynamic_data(output.x1, output.x2, output.x3, output.y1, output.y2, output.y3, n_age_strat,n_work_strat, t_SIP, t_reopen, t_end)

%daily data 6
close all 
clear
clc
W_multiplier =  0.8;
O_multiplier = 0.8;
S_multiplier = 0.8;
H_multiplier = 0.5;

t_SIP = 50;
t_reopen = 140;
t_end = 500;
N_zero_patient = 4;

W_multiplier_r = 1;
O_multiplier_r = 1;
S_multiplier_r = 1;
H_multipler_r = H_multiplier;

infect_rate = 0.03;
options_figure = 1;

fv_TWratio = 0
pv_TWratio = 0.5
nv_TWratio = 1
TOratio = 1
TSratio = 0.5
o_specialCare = 1

output = main2_phases_2016_reopen(W_multiplier, O_multiplier, S_multiplier, H_multiplier, W_multiplier_r,O_multiplier_r,S_multiplier_r,H_multipler_r, fv_TWratio, pv_TWratio, nv_TWratio, TOratio, TSratio, o_specialCare, t_SIP, t_reopen, t_end, N_zero_patient, infect_rate, options_figure)

n_age_strat = 3;
n_work_strat = 3;
daily_data = get_dynamic_data(output.x1, output.x2, output.x3, output.y1, output.y2, output.y3, n_age_strat,n_work_strat, t_SIP, t_reopen, t_end)