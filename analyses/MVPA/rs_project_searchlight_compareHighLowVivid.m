%% MVPA test script
clear all
%% Define variables
badImg = [6,9,12,13,16,18,20,22,24,25];
goodImg = [1,3,5,7,10,11,14,15,17,21,23,27,28];
condition={'FACE_PLACE_FAMILIARITY', 'FACE', 'PLACE', 'FACE_IDENTITY', 'PLACE_IDENTITY'};
accuracyGroup=[];
ds_cell_good=[];
ds_cell_bad=[];
%% Create datasets for the two groups
for iCond=1:length(condition)
    %Define paths
    if strcmp(condition{iCond}, 'FACE_IDENTITY') || strcmp(condition{iCond}, 'PLACE_IDENTITY')
        pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\searchlight\regular_leaveOneRunOut\matlab\';
        output_path='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\searchlight\regular_leaveOneRunOut\matlab\groupVividnessComparison\';
    else
        pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\searchlight\nchoosek_leaveOneRunOut\matlab\';
        output_path='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\searchlight\nchoosek_leaveOneRunOut\matlab\\groupVividnessComparison\';
    end
    %% Create group DS
    for iSub=1:length(goodImg)
        %Load searchlight
        ds_g=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_searchlight_LDA_100_%s_corrected.nii',goodImg(iSub), char(condition{iCond}))));
        ds_cell_good{iSub}=ds_g;
    end
    for iSub=1:length(badImg)
        %Load searchlight
        ds_b=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_searchlight_LDA_100_%s_corrected.nii',badImg(iSub), char(condition{iCond}))));
        ds_cell_bad{iSub}=ds_b;
    end
    
    %Compute intersection between participants
    [idxs,ds_intersect_cell_good]=cosmo_mask_dim_intersect(ds_cell_good);
    [idxs,ds_intersect_cell_bad]=cosmo_mask_dim_intersect(ds_cell_bad);
    %For (second level) group analysis, in general, it is a good idea to assign chunks (if not done already) and targets.
    %The general approach to setting chunks is by indicating that data from different participants is assumed to be independent;
    %Do it for good sub
    n_subjects=numel(ds_intersect_cell_good);
    for subject_i=1:n_subjects
        % get dataset
        ds_good=ds_intersect_cell_good{subject_i};
        
        % assign chunks
        n_samples=size(ds_good.samples,1);
        ds_good.sa.chunks=ones(n_samples,1)*subject_i;
        
        % assign targets (first group)
        ds_good.sa.targets=1;
        
        % store results
        ds_intersect_cell_good{subject_i}=ds_good;
    end
    %Stack all subjects toghether
    ds_all_good=cosmo_stack(ds_intersect_cell_good,1);
    %And for bad sub
    n_subjects=numel(ds_intersect_cell_bad);
    for subject_i=1:n_subjects
        % get dataset
        ds_bad=ds_intersect_cell_bad{subject_i};
        
        % assign chunks
        n_samples=size(ds_bad.samples,1);
        ds_bad.sa.chunks=ones(n_samples,1)*subject_i;
        
        % assign targets (second group)
        ds_bad.sa.targets=2;
        
        % store results
        ds_intersect_cell_bad{subject_i}=ds_bad;
    end
    %Stack all subjects toghether
    ds_all_bad=cosmo_stack(ds_intersect_cell_bad,1);
    
    % SAVE MAP
    %cosmo_map2fmri(ds_all,[fullfile(output_path,sprintf('group_searchlight_%s_N=%d_corrected.mat', condition, length(subList)))]); % questa mappa è la media dei dati di group_ds (17 celle) per ciascun voxel across subjects. Output = 1 cella x nr voxels
    cosmo_map2fmri(ds_all_good,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_good_corrected.vmp', char(condition{iCond}), length(goodImg)))]);
    cosmo_map2fmri(ds_all_good,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_good_corrected.nii.gz', char(condition{iCond}), length(goodImg)))]);
    cosmo_map2fmri(ds_all_bad,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_bad_corrected.vmp', char(condition{iCond}), length(badImg)))]);
    cosmo_map2fmri(ds_all_bad,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_bad_corrected.nii.gz', char(condition{iCond}), length(badImg)))]);
    
    %CREATE ONE SINGLE DATASET WITH BOTH GROUPS FOR STATISTIC
    ds_all=cosmo_stack({ds_all_good,ds_all_bad});
    %Reassign chunks to make each subject independent
    ds_all.sa.chunks = (1:(length(goodImg)+length(badImg)))';
    % COMPUTE TWO SAMPLES T-TEST
    % fa un one sample t test 1tail di ogni voxel contro chance level
    two_samples_ds =ds_all;
    stat_ds=cosmo_stat(two_samples_ds, 't2');
    stat_ds_p=cosmo_stat(two_samples_ds, 't2','p');
    %Correct t-test to be p=0.001. So, I assign to each p>0.05 value =1 so
    %that it is not considered
    p_thresh = [0.05, 0.01, 0.001];
    for f = 1:length(p_thresh)
        stat_ds_thresh = stat_ds;
        for i = 1:length(stat_ds_p.samples)
            if stat_ds_p.samples(i)>p_thresh(f)
                stat_ds_thresh.samples(i)=0;
            end
        end
        
        % SAVE ONE SAMPLE T TEST FIGURE IN MNI SPACE!!!!!!
        cosmo_map2fmri(stat_ds_thresh,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_groupVividComp_corrected_one_sample_t_%s.vmp', char(condition{iCond}), (length(goodImg)+length(badImg)), num2str(p_thresh(f))))]); % questa mappa è il t-test sui dati non corretti di group-ds
        cosmo_map2fmri(stat_ds_thresh,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_groupVividComp_corrected_one_sample_t_%s.nii', char(condition{iCond}), (length(goodImg)+length(badImg)), num2str(p_thresh(f))))]);
        cosmo_map2fmri(stat_ds_thresh,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_groupVividComp_corrected_one_sample_t_%s.nii.gz', char(condition{iCond}), (length(goodImg)+length(badImg)), num2str(p_thresh(f))))]);
        
        %Clear thresholded dataset
        stat_ds_thresh = [];
    end
    %% Apply FDR correction
    [result_fdr, result_crit_p, adj_ci_cvrg, adj_p]=fdr_bh(stat_ds_p.samples,0.05,'pdep','yes');
    %In result_fdr you have a binary mask with voxels that survives FDR
    %correction. Now select in stat_ds only the voxels that survived with their
    %t value and set others to 0
    stat_ds_fdr=stat_ds;
    for k=1:length(result_fdr)
        if result_fdr(k)==0
            stat_ds_fdr.samples(k)=0;
        end
    end
    %Salva output in nii.gz and vmp
    cosmo_map2fmri(stat_ds_fdr,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_groupVividComp_FDR_corrected.nii.gz', char(condition{iCond}), (length(goodImg)+length(badImg))))]);
    cosmo_map2fmri(stat_ds_fdr,[fullfile(output_path,sprintf('group_searchlight_LDA_%s_N=%d_groupVividComp_FDR_corrected.vmp', char(condition{iCond}), (length(goodImg)+length(badImg))))]);
end
