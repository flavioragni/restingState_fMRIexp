function rs_project_runsearchlight_LORO_perm_CLUSTER(subNum,condition)
%% MVPA test script
%Goal: import dataset from a single run, assign chunks, targets and labels.
%% Local paths for debugging
% addpath(genpath('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\toolbox\CoSMoMVPA-master\mvpa'));
% Cfg.pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\alignedMNI_3mm\';
% Cfg.output_path='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\searchlight\';
% addpath('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\toolbox\NIFTI_tools\');
%% Define paths and variables
Cfg=struct;
addpath(genpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa'));
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/external/NIfTI_20140122');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/external/NeuroElf_v11_7101');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/external/surfing-master');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/external/afni_matlab');
addpath(genpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/external/libsvm-3.22'));
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/NIFTI_tools');
Cfg.pathtodata='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/resting_state_project/mvpa/alignedMNI_3mm/';
Cfg.output_path='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/resting_state_project/mvpa/searchlight/regular_leaveOneRunOut/permutations/';
Cfg.nRuns=9;
Cfg.condition = condition;
% Cfg.condition='FACE_IDENTITY';%'FACEFAMILIAR_IDENTITY';%'PLACEFAMILIAR_IDENTITY';%'PLACENONFAMILIAR_IDENTITY';%'FACENONFAMILIAR_IDENTITY';%'PLACE_IDENTITY';%'FAMILIAR';%'FACE_PLACE';%'PLACE';%'FACE';%
chance=1/2;
accuracyGroup=[];
a=path;
save('/home/flavio.ragni/mat_path.mat','a');
%% N-fold cross-validation
%Remove bad runs
if subNum == 7
    Cfg.nRuns = 7;
    goodRuns = [1,2,3,4,5,6,7];
elseif subNum == 13
    Cfg.nRuns = 8
    goodRuns = [1,2,4,5,6,7,8,9];
end
for iRun=1:Cfg.nRuns
    %Remove bad runs
    if subNum == 7
        iRun = goodRuns(iRun)
    elseif subNum == 13
        iRun = goodRuns(iRun)
    end
    switch Cfg.condition
        case {'FACE_PLACE', 'FAMILIAR'}
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2, tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
            case {'FACE_PLACE_FAMILIAR'}
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            
            case {'FACE_PLACE_NONFAMILIAR'}
            %Create temporary variables for each cope image of interest
            tempF1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
            
        case 'FACE'
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[]; tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];
            
            
        case 'PLACE'
            %Create temporary variables for each cope image of interest
            tempP1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[]; tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
        case 'FACE_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];
            
        case 'PLACE_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempP1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
        case 'FACEFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];
            
        case 'PLACEFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempP1_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2})'])
            tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            
        case 'FACENONFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempF1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2})'])
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];
            
        case 'PLACENONFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempP1_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subNum,iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(Cfg.pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subNum,iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
    end
end

    
switch Cfg.condition
    %% Face/Place classification independent of familiarity:
    %  Train on two faces (1 familiar, 1 non familiar) and two places (1 familiar, 1 non familiar)
    %  and test on the 4 left out stimuli. Then do classification viceversa
    case 'FACE_PLACE'
        %Stack toghether ALL RUNS
        if subNum == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subNum == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Define tatgets, chunks and label for ds
        %Target 1 = Faces; Target 2 = Places
        targets=repmat((1:2)',2,4)';
        targets=targets(:);
        targets=repmat(targets,Cfg.nRuns,1);
        chunks=zeros((16*Cfg.nRuns),1);
        for i=1:Cfg.nRuns
            idxs=(i-1)*16+(1:16);
            chunks(idxs)=i;
        end
        labels=repmat({'Faces';'Places'},2,4)';
        labels=labels(:);
        labels=repmat(labels,Cfg.nRuns,1);
        %Set modality for decoding: 1=1 fam and 1 non fam faces, 1 fam and 1 non fam places,
        %                           2 = 1 fam and 1 non fam faces, 1 fam and 1 non fam places
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        
        %% Familiarity classification WITHIN category:
        %  WHITHIN each category (face or place separately), train on one
        %  familiar and one non familiar stimuli, and test on the two left out.
    case {'FACE', 'PLACE'}
        %Stack toghether ALL RUNS
        if subNum == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subNum == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Target 1 = Familiar; Target 2 = Non Familiar
        targets=repmat((1:2)',1,4)';
        targets=targets(:);
        targets=repmat(targets,Cfg.nRuns,1);
        chunks=zeros((8*Cfg.nRuns),1);
        for i=1:Cfg.nRuns
            idxs=(i-1)*8+(1:8);
            chunks(idxs)=i;
        end
        %Set modality for decoding: 1=1 fam and 1 non fam (face OR place),
        %                           2 = 1 fam and 1 non fam (face OR place)
        labels=repmat({'Familiar';'Non Familiar'},1,4)';
        labels=labels(:);
        labels=repmat(labels,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        
        %% Familiarity classification ACROSS category:
        %  Category INDEPENDENT familiarity classification.
        %  Train on faces (familiar and unfamiliar),
        %  test on places (familiar and unfamiliar), and viceversa
    case 'FAMILIAR'
        %Stack toghether all runs
        if subNum == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subNum == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Define tatgets, chunks and label for ds
        %Target 1 = Familiar; Target 2 = Non Familiar
        targets=repmat((1:2)',1,8)';
        targets=targets(:);
        targets=repmat(targets,Cfg.nRuns,1);
        chunks=zeros((16*Cfg.nRuns),1);
        for i=1:Cfg.nRuns
            idxs=(i-1)*16+(1:16);
            chunks(idxs)=i;
        end
        labels=repmat({'Familiar';'Non Familiar'},1,8)';
        labels=labels(:);
        labels=repmat(labels,Cfg.nRuns,1);
        %Set modality for decoding: 1=faces, 2 = places
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        
    case {'FACE_IDENTITY', 'PLACE_IDENTITY'}
        %Stack toghether ALL RUNS
        if subNum == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subNum == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Target 1 = Familiar; Target 2 = Non Familiar
        targets=repmat((1:4)',1,2)';
        targets=targets(:);
        targets=repmat(targets,Cfg.nRuns,1);
        chunks=zeros((8*Cfg.nRuns),1);
        for i=1:Cfg.nRuns
            idxs=(i-1)*8+(1:8);
            chunks(idxs)=i;
        end
        if strcmp(Cfg.condition, 'FACE_IDENTITY')
            labels=repmat({'Face1';'Face2';'Face3';'Face4'},1,2)';
        elseif strcmp(Cfg.condition, 'PLACE_IDENTITY')
            labels=repmat({'Place1';'Place2';'Place3';'Place4'},1,2)';
        end
        labels=labels(:);
        labels=repmat(labels,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        
    case {'FACEFAMILIAR_IDENTITY', 'PLACEFAMILIAR_IDENTITY', 'FACENONFAMILIAR_IDENTITY', 'PLACENONFAMILIAR_IDENTITY'}
        %Stack toghether ALL RUNS
        if subNum == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subNum == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Target 1 = Familiar; Target 2 = Non Familiar
        targets=repmat((1:2)',1,2)';
        targets=targets(:);
        targets=repmat(targets,Cfg.nRuns,1);
        chunks=zeros((4*Cfg.nRuns),1);
        for i=1:Cfg.nRuns
            idxs=(i-1)*4+(1:4);
            chunks(idxs)=i;
        end
        labels=repmat({'Stim1';'Stim2'},1,2)';
        labels=labels(:);
        labels=repmat(labels,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
end

if subNum == 7
    ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];ds6=[];ds7=[];
elseif subNum == 13
    ds1=[];ds2=[];ds4=[];ds5=[];ds6=[];ds7=[];ds8=[];ds9=[];
else
    ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];ds6=[];ds7=[];ds8=[];ds9=[];
end

%% Permutations
%Define iterations
niter=100;
%Set partitions
p=cosmo_nfold_partitioner(ds);
% BALANCE PARTITIONS
% make standard balancing
p=cosmo_balance_partitions(p,ds); 
% DEFINE nbrhood
nvoxels_per_searchlight=100;
nbrhood=cosmo_spherical_neighborhood(ds,'count', nvoxels_per_searchlight, 'progress',false); %  computes neighbors for a spherical searchlight   'radius',radius,

% RANDOMIZE TARGETS SHOULD DROP DECODING ACCURACY TO CHANCE LEVEL
%Prepare for permutations
%Make a copy of original dataset
ds0=ds;
%For niter iterations, reshuffle the labels and run the searchlight
for k=1:niter
    % per ogni p.test_indices
    for x = 1: length(p.test_indices)
        data = ds0.sa.targets(p.test_indices{x});
        ds0.sa.targets(p.test_indices{x}) = data(randperm(size(data,1)),:);
    end
    
    % define measure and its arguments; here crossvalidation with LDA
    % classifier to compute classification accuracies
    args=struct();
    args.classifier = @cosmo_classify_lda;
    args.partitions = p;
    
    measure=@cosmo_crossvalidation_measure;
    warning off
    %Run searchlight (without showing progress bar)
    perm_result{k}=cosmo_searchlight(ds0,nbrhood,measure,args);
    % save for every K (= nr iteration) a dataset result{k} with .sa .samples .fa .a of a
    % null distribution
    % save this, in every cell[100] a dataset
end
permuted_searchlight_name = [Cfg.output_path filesep sprintf('sub%02d_%s_LDA_%d_permuted_searchlight.mat',subNum,Cfg.condition,nvoxels_per_searchlight)];
save(permuted_searchlight_name,'perm_result');