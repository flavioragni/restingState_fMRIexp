function rs_project_create_runs(subNum)
%Set variables for experimental session
save_path = 'C:\Users\flavio.ragni\Google Drive\Resting state project\Scripts\trd\';
runNum = 9;
trialNum = 16;

%Fill first column of masterfile with shuffled trial codes for all 10 runs
for k = 1:runNum
    %Create vector with trials 
    trials = repmat(1:8,1,2);
    %Create structure that will be log file at the end of the actual task
    trial_struct = zeros(16,7);
    trial_struct(:,1) = trials(randperm(length(trials)));
    save(fullfile(save_path, sprintf('SUB%02d_RUN%02d_rs', subNum, k)), 'trial_struct');
end
