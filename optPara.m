
clear all

W_multiplierVec = 1;
%O_multiplierVec = 0.3:0.3:0.6;
O_multiplierVec = 0.3;
%H_multiplierVec = 0.1:0.1:0.2;
H_multiplierVec = 0.5;
N_zero_patientVec = 10;
infect_rateVec = 0.03;

penaltyValueMat = zeros(length(W_multiplierVec), length(O_multiplierVec), length(H_multiplierVec), length(N_zero_patientVec), length(infect_rateVec));
currBestPenalty = Inf;
tic
for i1 = 1:length(W_multiplierVec)
    disp(['i1 = ' num2str(i1)])
    W_multiplier = W_multiplierVec(i1);
    for i2 = 1:length(O_multiplierVec)
        disp(['i2 = ' num2str(i2)])
        O_multiplier = O_multiplierVec(i2);
        for i3 = 1:length(H_multiplierVec)
            disp(['i3 = ' num2str(i3)])
            H_multiplier = H_multiplierVec(i3);
            toc
            for i4 = 1:length(N_zero_patientVec)
                N_zero_patient =  N_zero_patientVec(i4);
                for i5 = 1:length(infect_rateVec)
                    infect_rate = infect_rateVec(i5);
                    penaltyValue = getPenalty(W_multiplier, O_multiplier, H_multiplier, N_zero_patient, infect_rate);
                    penaltyValueMat(i1,i2,i3,i4,i5) = penaltyValue;
                    if penaltyValue < currBestPenalty
                        best_i1 = i1; best_i2 = i2; best_i3 = i3; best_i4 = i4; best_i5 = i5;
                        currBestPenalty = penaltyValue;
                    end
                end
                    
            end
        end
    end
end
bestW_multiplier = W_multiplierVec(best_i1);
bestO_multiplier = O_multiplierVec(best_i2);
bestH_multiplier = H_multiplierVec(best_i3);
bestN_zero_patient = N_zero_patientVec(best_i4);
bestinfect_rate = infect_rateVec(best_i5);



bchmkData = [63	66	69	72	73	82	75	76	69	72	72	74	73	77	66	69	69	64	65	64	58	72	66	67	69	69	67	66	60	61	65	55	50	45	43	36	37	37	35	35
62	75	81	82	76	70	90	89	99	95	111	115	77	74	89	71	70	84	73	77	71	67	69	76	79	74	69	76	70	64	60	59	65	62	59	55	55	57	54	42
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	3	6	8	8	11	13	15	18	19	19	22	25	25	27	28	30	30	30	31	33];

options_figure = 0;
S_multiplier = 0;
per1Length = 50;
per2Length = 60;
per3Length = 20;

output = main2_phases_2016(bestW_multiplier, bestO_multiplier, S_multiplier, bestH_multiplier, per1Length, per1Length+per2Length, per1Length+per2Length+per3Length, bestN_zero_patient, bestinfect_rate, options_figure);

length_bchmkData = size(bchmkData,2);
bchmkStart = 12;


%{
figure
plot(1:(per1Length+per2Length), [output.resp_phase_1,output.resp_phase_2], 'r-');
hold on
plot(1:(per1Length+per2Length), [output.hosp_phase_1,output.hosp_phase_2], 'b-');
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(1,:), 'r:', 'LineWidth',2)
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(2,:), 'b:', 'LineWidth',2)
%}

figure
plot(1:(per1Length+per2Length), [output.resp_phase_1,output.resp_phase_2], 'r-');
hold on
plot(1:(per1Length+per2Length), [output.hosp_phase_1,output.hosp_phase_2], 'b-');
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(1,:), 'r:', 'LineWidth',2)
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(2,:), 'b:', 'LineWidth',2)




