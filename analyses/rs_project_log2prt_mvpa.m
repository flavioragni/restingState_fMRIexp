function rs_project_log2prt_mvpa(subNum, runNum)
%Set variables for experimental session
pathToLog = 'C:\\Users\\flavio.ragni\\Google Drive Unitn\\ERC_perceptual_awareness_resting_state_project\\Results\\fMRI\\log\\';
pathToOutput = 'C:\\Users\\flavio.ragni\\Google Drive Unitn\\ERC_perceptual_awareness_resting_state_project\\Results\\fMRI\\log\\MVPA\\';
%% Model Imagery
%Set number of repetition for each stimulus
nRep = 2; 
%Load log file
load(fullfile(pathToLog,sprintf('SUB%02d_RUN%02d_rs_log.mat', subNum, runNum)));

%Set timings and variables
Cfg.skipNVol=0;
Cfg.TR = 1;
Cfg.paramMod = 1; %can be used for parametric modulation

nTrials = length(trial_struct(:,1));
count = 0;
for i = 1 : nTrials
    ID(i)    = trial_struct(i,1);
    t(i)     = [trial_struct(i,3)];
end

%nStim = length(unique(stim));
nStim = length(unique(ID));

% code = stim;
% codeVec = unique(code);
code = ID;
codeVec = unique(ID);
stim_names = {'Face1_fam'; 'Face2_fam'; 'Place1_fam'; 'Place2_fam'; 'Face1_nonfam'; 'Face2_nonfam'; 'Place1_nonfam'; 'Place2_nonfam'};
prt.NrOfConditions = length(stim_names);
        
for i = 1 : length(codeVec)
    dat{i}.tStart = (t(find(code==codeVec(i)))) * 1000; %Added durPreDelay to consider only imagery delay
end
        
for c = 1:length(codeVec)
    eStartSec = dat{c}.tStart/1000;
    for j = 1:nRep
        fname = [pathToOutput sprintf('SUB%02d_RUN%02d_%s%d_mvpa.txt', subNum, runNum, char(stim_names(c)), j)];
        fileID = fopen(fname,'w');
        fprintf(fileID,'%03.3f %02.2f %02.0d\n', eStartSec(j), Cfg.timing.img_delay, Cfg.paramMod);
        fclose(fileID);
    end
end
dat = []; ID = []; t = [];

%%Model nuisance regressors
nuis_regr = {'Cue', 'Rating'};
events = [2, 4];
timing = [Cfg.timing.cue, Cfg.timing.rating];

for k = 1:length(nuis_regr)
    
    nTrials = length(trial_struct(:,1));
    
    for i = 1 : nTrials
        ID(i)    = trial_struct(i,events(k));
        t(i)     = [trial_struct(i,events(k))];
    end
    
    condName = nuis_regr{k};
    
    dat.tStart = t * 1000; %Added durPreDelay to consider only imagery delay
    
    eStartSec = dat.tStart/1000;
    fname = [pathToOutput sprintf('SUB%02d_RUN%02d_%s_mvpa.txt', subNum, runNum, condName)];
    fileID = fopen(fname,'w');
    for i = 1 : length(eStartSec)
        fprintf(fileID,'%03.3f %02.2f %02.0d\n', eStartSec(i), timing(k), Cfg.paramMod);
    end
    fclose(fileID);
end
end
