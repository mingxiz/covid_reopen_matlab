
function penaltyValue = getPenalty(W_multiplier, O_multiplier, H_multiplier, fvpvnvRatioVec, N_zero_patient, infect_rate)
% Written by Zhengli Wang %
% modified 2020/5/21

% Patient 0 assumed Jan. 26
% Phase 1: Jan. 26 - March 15
% Phase 2: March 16 - May 15

options_figure = 0;
S_multiplier = 0;
per1Length = 50;
per2Length = 60;
per3Length = 20;
output = main2_phases_2016(W_multiplier, O_multiplier, S_multiplier, H_multiplier,fvpvnvRatioVec, per1Length, per1Length+per2Length, per1Length+per2Length+per3Length, N_zero_patient, infect_rate, options_figure);

% bchmrkData from Match 27 to May 5
bchmkData = [63	66	69	72	73	82	75	76	69	72	72	74	73	77	66	69	69	64	65	64	58	72	66	67	69	69	67	66	60	61	65	55	50	45	43	36	37	37	35	35
62	75	81	82	76	70	90	89	99	95	111	115	77	74	89	71	70	84	73	77	71	67	69	76	79	74	69	76	70	64	60	59	65	62	59	55	55	57	54	42
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	3	6	8	8	11	13	15	18	19	19	22	25	25	27	28	30	30	30	31	33];

length_bchmkData = size(bchmkData,2);

bchmkStart = 12;
targetOutput = [output.resp_phase_2(bchmkStart:bchmkStart+length_bchmkData-1);
    output.hosp_phase_2(bchmkStart:bchmkStart+length_bchmkData-1);
    output.death_phase_2(bchmkStart:bchmkStart+length_bchmkData-1)];

diffMat = targetOutput - bchmkData;
diffMat = diffMat(1:2,:);   % exclude death
init_penaltyValue = sqrt(sum(diffMat(:).^2));

preTargetOutput = [output.resp_phase_1, output.resp_phase_2(1: bchmkStart-1);
    output.hosp_phase_1, output.hosp_phase_2(1: bchmkStart-1);
    output.death_phase_1, output.death_phase_2(1: bchmkStart-1)];
    
%addPenaltyMultiplier = 10^4;
addPenaltyMultiplier = 0;

% no. of entries larger than first day of benchmark data
nEntriesLarger = sum(sum(preTargetOutput > bchmkData(:,1)));
add_penaltyValue = nEntriesLarger*addPenaltyMultiplier;

penaltyValue = init_penaltyValue + add_penaltyValue;


%{
figure
plot(1:(per1Length+per2Length), [output.resp_phase_1,output.resp_phase_2], 'r-');
hold on
plot(1:(per1Length+per2Length), [output.hosp_phase_1,output.hosp_phase_2], 'b-');
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(1,:), 'r:', 'LineWidth',2)
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(2,:), 'b:', 'LineWidth',2)
title(['W = ' num2str(W_multiplier) ', O = ' num2str(O_multiplier) ', H = ' num2str(H_multiplier) ', n0 = ' num2str(N_zero_patient) ', infectRate = ' num2str(infect_rate) ])
saveName = [num2str(W_multiplier) num2str(O_multiplier) num2str(H_multiplier) num2str(N_zero_patient) num2str(infect_rate) '.png'];
saveas(gcf, saveName)
close(gcf)
%}
