clear all

W_multiplier = 0.6;
O_multiplier = 0.6;
H_multiplier = 1;
N_zero_patient = 10;
infect_rate = 0.03;
fvpvnvRatioVec = [0,0,0.5];
getPenalty(W_multiplier, O_multiplier, H_multiplier, fvpvnvRatioVec, N_zero_patient, infect_rate)


W_multiplier = 0.5;
O_multiplier = 0.6;
H_multiplier = 1;
N_zero_patient = 10;
infect_rate = 0.03;
fvpvnvRatioVec = [0,0,0.5];

getPenalty(W_multiplier, O_multiplier, H_multiplier, fvpvnvRatioVec, N_zero_patient, infect_rate)
