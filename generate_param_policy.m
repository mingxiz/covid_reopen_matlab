function param_policy = generate_param_policy

    param_policy.e = 1;
    % percentage of people under policy control (could be work X age specific)
    % each entry is in (0, 1)
    % assume (0.01, 0.999) following convention
    param_policy.policy_pct = [0.01 0.01 0.01; 0.01 0.01 0.01; 0.01 0.01 0.01];

