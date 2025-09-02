files = ["D:\F1 comparison report\MCL39 data\forces\20ms.csv";
    "D:\F1 comparison report\MCL39 data\forces\30ms.csv";
    "D:\F1 comparison report\MCL39 data\forces\40ms.csv";
    "D:\F1 comparison report\MCL39 data\forces\50ms.csv";
    "D:\F1 comparison report\MCL39 data\forces\60ms.csv";
    "D:\F1 comparison report\MCL39 data\forces\70ms.csv";];
cutoffTime = 500;   % seconds threshold for averages

speeds   = [];
avgFyAll = [];
avgFzAll = [];

figure(1); clf; set(gcf,'Color','w'); hold on; grid on;
xlabel('Time (s)'); ylabel('Downforce (N)');

figure(2); clf; set(gcf,'Color','w'); hold on; grid on;
xlabel('Time (s)'); ylabel('Drag (N)');

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

    it = find(contains(hlow,"time"),1);
    iy = find(contains(hlow,"y") & contains(hlow,"force"),1);
    iz = find(contains(hlow,"z") & contains(hlow,"force"),1);

    if isempty(it) || isempty(iy) || isempty(iz)
        warning('Skipping %s: could not find Time/Fy/Fz columns. Headers: %s', ...
                 fname, strjoin(headers, ', '));
        continue;
    end

    t  = T{:,it};
    Fy = 2 * T{:,iy};
    Fz = 2 * T{:,iz};

    figure(1);
    plot(t, Fy, 'LineWidth', 1.4, 'DisplayName', strcat(num2str(velocity^2), ' m/s'));

    figure(2);
    plot(t, Fz, 'LineWidth', 1.4, 'DisplayName', strcat(num2str(velocity), ' m/s'));

    mask = (t >= cutoffTime) & isfinite(Fy) & isfinite(Fz);
    if any(mask)
        avgFy = mean(Fy(mask), 'omitnan');
        avgFz = mean(Fz(mask), 'omitnan');
        fprintf('%s | Avg Downforce After %gs = %.6f | Avg Drag After %gs = %.6f\n', ...
                 strcat(num2str(velocity), ' m/s'), cutoffTime, avgFy, cutoffTime, avgFz);

        tok = regexp(fname, '(?<spd>\d+(\.\d+)?)\s*(m\/s|mps|ms)', 'names', 'ignorecase');
        if ~isempty(tok)
            spd = str2double(tok(1).spd);
        else
            % Fallback: first number in the filename
            rawNum = regexp(fname, '\d+(\.\d+)?', 'match', 'once');
            spd = str2double(rawNum);
        end

        if ~isnan(spd)
            speeds(end+1)   = spd;   %#ok<SAGROW>
            avgFyAll(end+1) = avgFy; %#ok<SAGROW>
            avgFzAll(end+1) = avgFz; %#ok<SAGROW>
        else
            warning('Could not parse speed from filename: %s', fname);
        end
    else
        fprintf('%s | No data after %gs.\n', fname, cutoffTime);
    end
end

figure(1); legend('Location','best');
figure(2); legend('Location','best');

% Average Fy vs Speed
if ~isempty(speeds)
    [spds, idx] = sort(speeds);
    FyAvgSorted = avgFyAll(idx);

    figure(3); clf; set(gcf,'Color','w'); hold on; grid on;
    plot(spds, FyAvgSorted, '-o', 'LineWidth', 1.6, 'MarkerSize', 6);
    xlabel('Velocity (m/s)'); ylabel(sprintf('Avg Downforce After %gs (N)', cutoffTime));
end

% Average Fz vs Speed
if ~isempty(speeds)
    [spds, idx] = sort(speeds);
    FzAvgSorted = avgFzAll(idx);

    figure(4); clf; set(gcf,'Color','w'); hold on; grid on;
    plot(spds, FzAvgSorted, '-o', 'LineWidth', 1.6, 'MarkerSize', 6);
    xlabel('Velocity (m/s)'); ylabel(sprintf('Avg Drag After %gs (N)', cutoffTime));
end

