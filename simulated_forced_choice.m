tbl     = table;

% Parameters
nsubj = 50;
nTrials = 500;
for i = 1:nsubj
stimulus = randsample([-1 1], nTrials, true);
contrast = randsample([0.5 0.75 1.25 1.5], nTrials, true);
previous = zeros(1, nTrials);
state = zeros(1, nTrials);

% Transition matrix for hidden states (2-state Markov)
% Rows: current state, Columns: next state
% quasi-stable: 90% chance to stay in same state
T = [0.9 0.1;
     0.1 0.9];

% Beta coefficients
intercept_ext = 2;
beta_stim_ext = 5;
beta_prev_ext = 3;  

intercept_int = 2;
beta_stim_int = 3;
beta_prev_int = 5;

% Initialize
state(1) = randi(2);  % Random initial state (1 or 2)
resp = zeros(1, nTrials);
obs = ones(1, nTrials);

% Loop through trials
for t = 1:nTrials
    if t > 1
        previous(t) = randsample(stimulus,1);  % or stimulus(t-1)
        prev_state = state(t-1);
        state(t) = randsample([1 2], 1, true, T(prev_state,:));
    end
end

% ----- Normalize predictors -----
stim_x_contrast = stimulus .* contrast;
%stim_x_contrast_norm = (stim_x_contrast - mean(stim_x_contrast)) / std(stim_x_contrast);
%previous_norm = (previous - mean(previous)) / std(previous);
% --------------------------------

% Loop through trials again to generate responses
for t = 1:nTrials
    if state(t) == 1
        linpred = intercept_ext + beta_stim_ext * stim_x_contrast(t) + beta_prev_ext * previous(t);
    elseif state(t) == 2
        linpred = intercept_int + beta_stim_int * stim_x_contrast(t) + beta_prev_int * previous(t);
    end

    % Logistic transformation
    p = 1 / (1 + exp(-linpred));
    resp(t) = randsample([-1 1], 1, true, [1-p, p]);
end

% Compile into table
TBL = table(obs', resp', stimulus', previous', contrast', state', ...
    'VariableNames', {'obs', 'resp', 'stimulus', 'previous', 'contrast', 'state'});

% Show first few rows
disp(TBL(1:12,:));

%
% Fit GLM for State 1
idx1 = TBL.state == 1;
X1 = [ ...
      TBL.stimulus(idx1).* TBL.contrast(idx1), ...
      TBL.previous(idx1)];  % Include previous for completeness
y1 = (TBL.resp(idx1) + 1) / 2;  % Convert -1/1 to 0/1

[b1, dev1, stats1] = glmfit(X1, y1, 'binomial', 'link', 'logit');


% Fit GLM for State 2
idx2 = TBL.state == 2;
X2 = [ ...
      TBL.stimulus(idx2) .* TBL.contrast(idx2), ...
      TBL.previous(idx2)];
y2 = (TBL.resp(idx2) + 1) / 2;

[b2, dev2, stats2] = glmfit(X2, y2, 'binomial', 'link', 'logit');

% Display results
fprintf('--- GLM Fit for State 1 ---\n');
fprintf('Intercept:       %.2f (p=%.3f)\n', b1(1), stats1.p(1));
fprintf('Stim*Contrast:   %.2f (p=%.3f)\n', b1(2), stats1.p(2));
fprintf('Previous:        %.2f (p=%.3f)\n', b1(3), stats1.p(3));

fprintf('\n--- GLM Fit for State 2 ---\n');
fprintf('Intercept:       %.2f (p=%.3f)\n', b2(1), stats2.p(1));
fprintf('Stim*Contrast:   %.2f (p=%.3f)\n', b2(2), stats2.p(2));
fprintf('Previous:        %.2f (p=%.3f)\n', b2(3), stats2.p(3));

TBL.obs     = i.*ones(size(TBL.resp));

tbl = vertcat(tbl,TBL);

end

% Optional: export to CSV
writetable(tbl, 'simulated_forced_choice.csv');

%% congruent analysis