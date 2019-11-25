%rs_project_extract_ratings.m - Extracts ratings for each participant and run, ordered by trial type.

%% Define Variables
clear all
pathToLog = 'C:\\Users\\flavio.ragni\\Google Drive Unitn\\ERC_perceptual_awareness_resting_state_project\\Results\\fMRI\\log\\';
pathToOutput = 'C:\\Users\\flavio.ragni\\Google Drive Unitn\\ERC_perceptual_awareness_resting_state_project\\Results\\fMRI\\log\\';
subList = [1, 2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 27, 28];
nRuns = 9;
output_ratings = zeros(144, length(subList));
output_RTs = zeros(144, length(subList));
%% Rating extraction
for iSub = 1:length(subList)
    temp_rating = [];
    temp_RTs = [];
    for iRun = 1:nRuns
        temp_run_ratings = zeros(16,1);
        temp_run_RTs = zeros(16,1);
        %Load log file corresponding to iRun
        load(fullfile(pathToLog,sprintf('SUB%02d_RUN%02d_rs_log.mat', subList(iSub), iRun)));
        trials_type = [1,2,3,4,5,6,7,8];
        for i = 1:length(trial_struct(:,1))
            if ismember(trial_struct(i,1), trials_type) && ~isempty(trials_type)
                if trial_struct(i,1) == 1
                    temp_run_ratings(1,1) = trial_struct(i,6);
                    temp_run_RTs(1,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                elseif trial_struct(i,1) == 2
                    temp_run_ratings(3,1) = trial_struct(i,6);
                    temp_run_RTs(3,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                elseif trial_struct(i,1) == 3
                    temp_run_ratings(5,1) = trial_struct(i,6);
                    temp_run_RTs(5,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                elseif trial_struct(i,1) == 4
                    temp_run_ratings(7,1) = trial_struct(i,6);
                    temp_run_RTs(7,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                elseif trial_struct(i,1) == 5
                    temp_run_ratings(9,1) = trial_struct(i,6);
                    temp_run_RTs(9,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                elseif trial_struct(i,1) == 6
                    temp_run_ratings(11,1) = trial_struct(i,6);
                    temp_run_RTs(11,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                elseif trial_struct(i,1) == 7
                    temp_run_ratings(13,1) = trial_struct(i,6);
                    temp_run_RTs(13,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                elseif trial_struct(i,1) == 8
                    temp_run_ratings(15,1) = trial_struct(i,6);
                    temp_run_RTs(15,1) = trial_struct(i,7);
                    trials_type(trials_type == trial_struct(i,1)) = [];
                end
            else
                 if trial_struct(i,1) == 1
                    temp_run_ratings(2,1) = trial_struct(i,6);
                    temp_run_RTs(2,1) = trial_struct(i,7);
                elseif trial_struct(i,1) == 2
                    temp_run_ratings(4,1) = trial_struct(i,6);
                    temp_run_RTs(4,1) = trial_struct(i,7);
                elseif trial_struct(i,1) == 3
                    temp_run_ratings(6,1) = trial_struct(i,6);
                    temp_run_RTs(6,1) = trial_struct(i,7);
                elseif trial_struct(i,1) == 4
                    temp_run_ratings(8,1) = trial_struct(i,6);
                    temp_run_RTs(8,1) = trial_struct(i,7);
                elseif trial_struct(i,1) == 5
                    temp_run_ratings(10,1) = trial_struct(i,6);
                    temp_run_RTs(10,1) = trial_struct(i,7);
                elseif trial_struct(i,1) == 6
                    temp_run_ratings(12,1) = trial_struct(i,6);
                    temp_run_RTs(12,1) = trial_struct(i,7);
                elseif trial_struct(i,1) == 7
                    temp_run_ratings(14,1) = trial_struct(i,6);
                    temp_run_RTs(14,1) = trial_struct(i,7);
                elseif trial_struct(i,1) == 8
                    temp_run_ratings(16,1) = trial_struct(i,6);
                    temp_run_RTs(16,1) = trial_struct(i,7);
                 end                 
            end
        end
        temp_rating = [temp_rating; temp_run_ratings];
        temp_RTs = [temp_RTs; temp_run_RTs];
    end
    output_ratings(:,iSub) = temp_rating;
    output_RTs(:,iSub) = temp_RTs;
    temp_rating = [];
    temp_RTs = [];
end
