clear all
fileName = 'tested_grid'
fullFileName = 'tested_grid.mat'
if exist(fullFileName, 'file')
  load(fileName)
else
  tested_grid = containers.Map
end

fvpvnvRatioVec = [0,0,0.5];

keys = keys(tested_grid)

currBestPenalty = Inf;
tic

for i = 1:length(tested_grid)
  disp(num2str(i));
  disp(char(keys(i)));
  disp(str2num(char(keys(i))));
  param = str2num(char(keys(i)));
  W_multiplier = param(1);
  O_multiplier = param(2);
  H_multiplier = param(3);
  N_zero_patient = param(4);
  infect_rate = param(5);

  penaltyValue = tested_grid(char(keys(i)))

  if penaltyValue < currBestPenalty
      bestW_multiplier = W_multiplier;
      bestO_multiplier = O_multiplier;
      bestH_multiplier = H_multiplier;
      bestN_zero_patient = N_zero_patient;
      bestinfect_rate = infect_rate;
      currBestPenalty = penaltyValue;
  end
end


bchmkData = [63	66	69	72	73	82	75	76	69	72	72	74	73	77	66	69	69	64	65	64	58	72	66	67	69	69	67	66	60	61	65	55	50	45	43	36	37	37	35	35
62	75	81	82	76	70	90	89	99	95	111	115	77	74	89	71	70	84	73	77	71	67	69	76	79	74	69	76	70	64	60	59	65	62	59	55	55	57	54	42
0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	3	6	8	8	11	13	15	18	19	19	22	25	25	27	28	30	30	30	31	33];

options_figure = 0;
S_multiplier = 0;
per1Length = 50;
per2Length = 60;
per3Length = 20;

output = main2_phases_2016(bestW_multiplier, bestO_multiplier, S_multiplier, bestH_multiplier,fvpvnvRatioVec, per1Length, per1Length+per2Length, per1Length+per2Length+per3Length, bestN_zero_patient, bestinfect_rate, options_figure);

length_bchmkData = size(bchmkData,2);
bchmkStart = 12;

figure
plot(1:(per1Length+per2Length), [output.resp_phase_1,output.resp_phase_2], 'r-');
hold on
plot(1:(per1Length+per2Length), [output.hosp_phase_1,output.hosp_phase_2], 'b-');
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(1,:), 'r:', 'LineWidth',2)
plot((per1Length + bchmkStart):(per1Length + bchmkStart + length_bchmkData - 1), bchmkData(2,:), 'b:', 'LineWidth',2)

similar_sol = 0;

for i = 1:length(tested_grid)
  param = str2num(char(keys(i)))
  W_multiplier = param(1)
  O_multiplier = param(2)
  H_multiplier = param(3)
  N_zero_patient = param(4)
  infect_rate = param(5)

  penaltyValue = tested_grid(char(keys(i)))

  if abs(penaltyValue - currBestPenalty) < 5
    similar_sol = similar_sol + 1

    output = main2_phases_2016(W_multiplier, O_multiplier, S_multiplier, H_multiplier,fvpvnvRatioVec, per1Length, per1Length+per2Length, per1Length+per2Length+per3Length, N_zero_patient, infect_rate, options_figure);

    plot(1:(per1Length+per2Length), [output.resp_phase_1,output.resp_phase_2], 'r-');
    hold on
    plot(1:(per1Length+per2Length), [output.hosp_phase_1,output.hosp_phase_2], 'b-');

    disp(['Best Penalty = ' num2str(currBestPenalty)])
    disp(['Penalty Value = ' num2str(penaltyValue)])
    disp(['W_multiplier = ' num2str(W_multiplier)])
    disp(['O_multiplier = ' num2str(O_multiplier)])
    disp(['H_multiplier = ' num2str(H_multiplier)])
    disp(['N_zero_patient = ' num2str(N_zero_patient)])
    disp(['infect_rate = ' num2str(infect_rate)])

  end
end
