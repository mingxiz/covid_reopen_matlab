function param_policy = generate_param_policy

    param_policy.e = 0.1;
    % percentage of people under policy control (could be work X age specific)
    % each entry is in (0, 1)
    param_policy.policy_pct = [0.99 0.5 0.1; 0.99 0.5 0.1; 0.99 0.99 0.99];

