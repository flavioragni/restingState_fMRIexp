function rs_project_log2prt_univariate(subNum, runNum)
%Set variables for experimental session
pathToLog = 'C:\\Users\\flavio.ragni\\Google Drive Unitn\\ERC_perceptual_awareness_resting_state_project\\Results\\fMRI\\log\\';
pathToOutput = 'C:\\Users\\flavio.ragni\\Google Drive Unitn\\ERC_perceptual_awareness_resting_state_project\\Results\\fMRI\\log\\';
%% Model Imagery
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
stim_names = {'Face_fam'; 'Place_fam'; 'Face_nonfam'; 'Place_nonfam'};
prt.NrOfConditions = length(stim_names);
        
for i = 1 : length(codeVec)
    dat{i}.tStart = (t(find(code==codeVec(i)))) * 1000; %Added durPreDelay to consider only imagery delay
end
        
for c = 1:length(stim_names)
    if c == 1
        eStartSec1 = dat{1}.tStart/1000;
        eStartSec2 = dat{2}.tStart/1000;
        eStartSec = [eStartSec1, eStartSec2];
        eStartSec = sort(eStartSec);
        fname = [pathToOutput sprintf('SUB%02d_RUN%02d_%s_univariate.txt', subNum, runNum, char(stim_names(c)))];
        fileID = fopen(fname,'w');
        for i = 1 : length(eStartSec)
            fprintf(fileID,'%03.3f %02.2f %02.0d\n', eStartSec(i), Cfg.timing.img_delay, Cfg.paramMod);
        end
        fclose(fileID);
        eStartSec = [];
    elseif c ==2
        eStartSec3 = dat{3}.tStart/1000;
        eStartSec4 = dat{4}.tStart/1000;
        eStartSec = [eStartSec3, eStartSec4];
        eStartSec = sort(eStartSec);
        fname = [pathToOutput sprintf('SUB%02d_RUN%02d_%s_univariate.txt', subNum, runNum, char(stim_names(c)))];
        fileID = fopen(fname,'w');
        for i = 1 : length(eStartSec)
            fprintf(fileID,'%03.3f %02.2f %02.0d\n', eStartSec(i), Cfg.timing.img_delay, Cfg.paramMod);
        end
        fclose(fileID);
        eStartSec = [];
    elseif c ==3
        eStartSec5 = dat{5}.tStart/1000;
        eStartSec6 = dat{6}.tStart/1000;
        eStartSec = [eStartSec5, eStartSec6];
        eStartSec = sort(eStartSec);
        fname = [pathToOutput sprintf('SUB%02d_RUN%02d_%s_univariate.txt', subNum, runNum, char(stim_names(c)))];
        fileID = fopen(fname,'w');
        for i = 1 : length(eStartSec)
            fprintf(fileID,'%03.3f %02.2f %02.0d\n', eStartSec(i), Cfg.timing.img_delay, Cfg.paramMod);
        end
        fclose(fileID);
        eStartSec = [];
    elseif c ==4
        eStartSec7 = dat{7}.tStart/1000;
        eStartSec8 = dat{8}.tStart/1000;
        eStartSec = [eStartSec7, eStartSec8];
        eStartSec = sort(eStartSec);
        fname = [pathToOutput sprintf('SUB%02d_RUN%02d_%s_univariate.txt', subNum, runNum, char(stim_names(c)))];
        fileID = fopen(fname,'w');
        for i = 1 : length(eStartSec)
            fprintf(fileID,'%03.3f %02.2f %02.0d\n', eStartSec(i), Cfg.timing.img_delay, Cfg.paramMod);
        end
        fclose(fileID);
        eStartSec = [];
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
    fname = [pathToOutput sprintf('SUB%02d_RUN%02d_%s_univariate.txt', subNum, runNum, condName)];
    fileID = fopen(fname,'w');
    for i = 1 : length(eStartSec)
        fprintf(fileID,'%03.3f %02.2f %02.0d\n', eStartSec(i), timing(k), Cfg.paramMod);
    end
    fclose(fileID);
end
end
