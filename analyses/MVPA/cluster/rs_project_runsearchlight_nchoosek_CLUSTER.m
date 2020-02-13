function rs_project_runsearchlight_nchoosek_CLUSTER(subNum, condition)
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
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/CoSMoMVPA-master/mvpa/external/libsvm-3.22');
addpath('/mnt/storage/tier1/anglin/LINANG001QX2/flavio/toolbox/NIFTI_tools');
Cfg.pathtodata='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/resting_state_project/mvpa/alignedMNI_3mm/';
Cfg.output_path='/mnt/storage/tier1/anglin/LINANG001QX2/flavio/resting_state_project/mvpa/searchlight/nchoosek_leaveOneRunOut/SVM/';
Cfg.nRuns=9;
Cfg.condition = condition;
%Cfg.condition='PLACE';%'FACE_PLACE_NONFAMILIAR'; %'FACE_PLACE_FAMILIAR'; %'FACE';%'FAMILIAR';%'FACE_PLACE';%
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
        case {'FACE_PLACE', 'FACE_PLACE_FAMILIARITY', 'FAMILIAR'}
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
        stimType=zeros((16*Cfg.nRuns),1);
        stimType=repmat((1:2)',4,2)';
        stimType=stimType(:);
        stimType=repmat(stimType,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
        
    case 'FACE_PLACE_FAMILIARITY'
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
        stimType=zeros((16*Cfg.nRuns),1);
        stimType=repmat((1:2)',1,8)';
        stimType=stimType(:);
        stimType=repmat(stimType,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
        
    case {'FACE_PLACE_FAMILIAR', 'FACE_PLACE_NONFAMILIAR'}
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
        targets=repmat((1:2)',1,4)';
        targets=targets(:);
        targets=repmat(targets,Cfg.nRuns,1);
        chunks=zeros((8*Cfg.nRuns),1);
        for i=1:Cfg.nRuns
            idxs=(i-1)*8+(1:8);
            chunks(idxs)=i;
        end
        labels=repmat({'Faces';'Places'},1,4)';
        labels=labels(:);
        labels=repmat(labels,Cfg.nRuns,1);
        %Set modality for decoding: 1=1 fam and 1 non fam faces, 1 fam and 1 non fam places,
        %                           2 = 1 fam and 1 non fam faces, 1 fam and 1 non fam places
        stimType=zeros((8*Cfg.nRuns),1);
        stimType=repmat((1:2)',2,2)';
        stimType=stimType(:);
        stimType=repmat(stimType,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
        
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
        stimType=zeros((16*Cfg.nRuns),1);
        stimType=repmat((1:2)',2,2)';
        stimType=stimType(:);
        stimType=repmat(stimType,Cfg.nRuns,1);
        labels=repmat({'Familiar';'Non Familiar'},1,4)';
        labels=labels(:);
        labels=repmat(labels,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
        
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
        stimType=zeros((16*Cfg.nRuns),1);
        stimType=repmat((1:2)',2,4)';
        stimType=stimType(:);
        stimType=repmat(stimType,Cfg.nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
end

if subNum == 7
    ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];ds6=[];ds7=[];
elseif subNum == 13
    ds1=[];ds2=[];ds4=[];ds5=[];ds6=[];ds7=[];ds8=[];ds9=[];
else
    ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];ds6=[];ds7=[];ds8=[];ds9=[];
end
%Function GTD_makeds_mvpa retun ds for currentSub already cleaned and
%masked
%% SVM classifier searchlight analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This analysis identified brain regions where the categories can be
% distinguished using an odd-even partitioning scheme and a Naive Bayes
% classifier.
% set parameters for naive bayes searchlight (partitions) in a
% measure_args struct.
%% SVM classifier searchlight analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This analysis identified brain regions where the categories can be
% distinguished using an odd-even partitioning scheme and a Naive Bayes
% classifier.
% set parameters for naive bayes searchlight (partitions) in a
% measure_args struct.
args=struct();
%args.classifier = @cosmo_classify_lda;
args.classifier = @cosmo_classify_libsvm;
%Set measures
measure=@cosmo_crossvalidation_measure;
%test_modality=2; %Test on imagery, train on perception
%test_modality=1; %Test on perception, train on imagery
%args.partitions=cosmo_nchoosek_partitioner(ds,1,'modality',test_modality);
args.partitions=cosmo_nchoosek_partitioner(ds,1,'stimType',[]);%Test in both directions
args.partitions=cosmo_balance_partitions(args.partitions,ds);
args.output='accuracy';

% print measure and arguments
fprintf('Searchlight measure arguments:\n');
cosmo_disp(args);
% Define a neighborhood with approximately 100 voxels in each searchlight.
nvoxels_per_searchlight=100;
nbrhood=cosmo_spherical_neighborhood(ds,'count',nvoxels_per_searchlight);
%% Run the searchlight
nb_results = cosmo_searchlight(ds,nbrhood,measure,args);

%% Store results to disc
cosmo_map2fmri(nb_results,fullfile(Cfg.output_path,sprintf('SUB%02d_searchlight_%d_%s.nii.gz',subNum,nvoxels_per_searchlight,Cfg.condition)));
