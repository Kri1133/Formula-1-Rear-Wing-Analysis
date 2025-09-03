files = {"D:\F1 comparison report\W11 data\coefficients\20ms.csv";
    "D:\F1 comparison report\W11 data\coefficients\30ms.csv";
    "D:\F1 comparison report\W11 data\coefficients\40ms.csv";
    "D:\F1 comparison report\W11 data\coefficients\50ms.csv";
    "D:\F1 comparison report\W11 data\coefficients\60ms.csv";
    "D:\F1 comparison report\W11 data\coefficients\70ms.csv";};
cutoffTime = 300;   % time (s) after which averages are calculated

speeds = [];
avgCL  = [];
avgCD  = [];
eff    = [];   % efficiency = |CL| / CD

for i = 1:numel(files)
    switch i
        case 1
            velocity = 20;
        case 2
            velocity = 30;
        case 3
            velocity = 40;
        case 4
            velocity = 50;
        case 5
            velocity = 60;
        case 6
            velocity = 70;
        otherwise
            velocity = NaN;
    end
    fname = files{i};
    T = readtable(fname, 'PreserveVariableNames', true, 'TextType', 'string');

    headers = string(T.Properties.VariableNames);
    hlow    = lower(headers);

    it  = find(contains(hlow,"time"),1);
    iCL = find(contains(hlow,"cl"),1);
    iCD = find(contains(hlow,"cd"),1);

    t  = T{:,it};
    CL = T{:,iCL};
    CD = T{:,iCD};

    mask = (t >= cutoffTime);
    avgCL_val = mean(CL(mask),'omitnan');
    avgCD_val = mean(CD(mask),'omitnan');

    tok = regexp(fname, '(\d+)', 'match', 'once');
    spd = velocity;

    speeds(end+1) = velocity  ;
    avgCL(end+1)  = avgCL_val;
    avgCD(end+1)  = avgCD_val;
    eff(end+1)    = abs(avgCL_val)/avgCD_val;

    fprintf('U = %2d m/s | Avg CL = %.5f | Avg CD = %.5f | Efficiency = %.5f\n', ...
             spd, avgCL_val, avgCD_val, abs(avgCL_val)/avgCD_val);
end

[speeds, idx] = sort(speeds);
avgCL = avgCL(idx);
avgCD = avgCD(idx);
eff   = eff(idx);

figure('Color','w'); hold on; grid on;
plot(speeds, avgCL, '-o', 'LineWidth', 1.6, 'MarkerSize', 6, 'DisplayName','Avg C_L');
plot(speeds, avgCD, '-s', 'LineWidth', 1.6, 'MarkerSize', 6, 'DisplayName','Avg C_D');
xlabel('Freestream Velocity U_\infty (m/s)');
ylabel('Coefficient');
title('Average Lift and Drag Coefficients vs Freestream Velocity');
legend('Location','best');

figure('Color','w'); hold on; grid on;
plot(speeds, eff, '-^', 'LineWidth', 1.6, 'MarkerSize', 6, 'DisplayName','|C_L| / C_D');
xlabel('Freestream Velocity U_\infty (m/s)');
ylabel('Efficiency (|C_L| / C_D)');
title('Aerodynamic Efficiency vs Freestream Velocity');
legend('Location','best');

fprintf('Cd average = %.6f\n', mean(avgCD));
fprintf('Cl average = %.6f\n', mean(avgCL));

fprintf('Eff average = %.6f\n', mean(eff));
