function daily_data = get_dynamic_data(x1, x2, x3, y1, y2, y3, n_age_strat,n_work_strat, t_SIP, t_reopen, t_end)

phase_1_data = zeros(n_age_strat, n_work_strat, 8, length([1:1:t_SIP]));
for i = 1:n_age_strat
    for j = 1:n_work_strat
        % S E UI DI UA DA R D
        for k = 1:8
            crt_y_np = zeros(1,length(x1));
            crt_y_p = zeros(1,length(x1));
            for index = 1:length(x1)
                crt_y_np(1,index) = y1(i, j, 1, k, index);
                crt_y_p(1,index) = y1(i, j, 2, k, index);
            end
            crt_y = crt_y_np + crt_y_p;
            phase_1_data(i, j ,k ,:)=interp1(x1,crt_y,[1:1:t_SIP]);
        end
    end
end


phase_2_data = zeros(n_age_strat, n_work_strat, 8, length([t_SIP+1:1:t_reopen]));
for i = 1:n_age_strat
    for j = 1:n_work_strat
        % S E UI DI UA DA R D
        for k = 1:8
            crt_y_np = zeros(1,length(x2));
            crt_y_p = zeros(1,length(x2));
            for index = 1:length(x2)
                crt_y_np(1,index) = y2(i, j, 1, k, index);
                crt_y_p(1,index) = y2(i, j, 2, k, index);
            end
            crt_y = crt_y_np + crt_y_p;
            phase_2_data(i, j ,k ,:)=interp1(x2,crt_y,[t_SIP+1:1:t_reopen]);
        end
    end
end


phase_3_data = zeros(n_age_strat, n_work_strat, 8, length([t_reopen+1:1:t_end]));
for i = 1:n_age_strat
    for j = 1:n_work_strat
        % S E UI DI UA DA R D
        for k = 1:8
            crt_y_np = zeros(1,length(x3));
            crt_y_p = zeros(1,length(x3));
            for index = 1:length(x3)
                crt_y_np(1,index) = y3(i, j, 1, k, index);
                crt_y_p(1,index) = y3(i, j, 2, k, index);
            end
            crt_y = crt_y_np + crt_y_p;
            phase_3_data(i, j ,k ,:)=interp1(x3,crt_y,[t_reopen+1:1:t_end]);
        end
    end
end

daily_data.phase_1_data = phase_1_data;
daily_data.phase_2_data = phase_2_data;
daily_data.phase_3_data = phase_3_data;
