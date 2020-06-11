fv_daily_output = 637.6633238;
pv_daily_output = 629.2960209;
nv_daily_output = 227.8112446;

daily_outputs = [fv_daily_output, pv_daily_output, nv_daily_output];

total_econ_value_phase_1 = 0;
total_econ_value_phase_2 = 0;
total_econ_value_phase_3 = 0;

phase_1_length = 50;
phase_2_length = 60;
phase_3_length = 50;

phase_2_PV_W_ratio = 0;
phase_2_others_ratio = 0.48;

phase_3_PV_W_ratio = 0.5;
phase_3_others_ratio = 0.8;

phase_2_reductions = [1, 0.5+0.5 * phase_2_PV_W_ratio, phase_2_others_ratio];

phase_3_reductions = [1, 0.5+0.5 * phase_3_PV_W_ratio, phase_3_others_ratio];

productiveClasses = [1,2,5,7];

for age = 1:3
    for virt = 1:3
        for class = 1:length(productiveClasses)
            for time = 1:phase_1_length
                    total_econ_value_phase_1 = total_econ_value_phase_1 + daily_outputs(virt) * daily_data.phase_1_data(age, virt, class, time);
            end
        end
    end
end

disp(total_econ_value_phase_1)

for age = 1:3
    for virt = 1:3
        for class = 1:length(productiveClasses)
            for time = 1:phase_2_length
                    total_econ_value_phase_2 = total_econ_value_phase_2 + daily_outputs(virt) * phase_2_reductions(virt) * daily_data.phase_2_data(age, virt, class, time);
            end
        end
    end
end

disp(total_econ_value_phase_2)

for age = 1:3
    for virt = 1:3
        for class = 1:length(productiveClasses)
            for time = 1:phase_3_length
                    total_econ_value_phase_3 = total_econ_value_phase_3 + daily_outputs(virt) * phase_3_reductions(virt) * daily_data.phase_3_data(age, virt, class, time);
            end
        end
    end
end

disp(total_econ_value_phase_3)