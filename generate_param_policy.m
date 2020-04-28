function param_policy = generate_param_policy

%  SEIR Model for COVID-19 reopenning project
%  Written for MATLAB_R2019b
%  Copyright (C) 2020
%     Mingxi Zhu <mingxiz@stanford.edu>

    param_policy.e = 1;
    % percentage of people under policy control (could be work X age specific)
    % each entry is in (0, 1)
    % assume (0.01, 0.999) following convention
    param_policy.policy_pct = [0.01 0.01 0.01; 0.01 0.01 0.01; 0.01 0.01 0.01];

