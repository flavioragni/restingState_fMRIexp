%% MVPA test script
clear all
%Goal: import dataset from a single run, assign chunks, targets and labels.
pathtodata='/mnt/raidVol2/flavio.ragni/resting_state_project/mvpa/alignedMNI_3mm/';
pathtorois='/mnt/raidVol2/flavio.ragni/resting_state_project/rois/OleggioCastello/alignedMNI/';
outputpath='/mnt/raidVol2/flavio.ragni/resting_state_project/mvpa/permutations/single_sub_permutations';
addpath(genpath('/mnt/raidVol2/flavio.ragni/toolbox/CoSMoMVPA-master/'));
subList=[1,3,5,6,7,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,27,28];
nRuns=9;
condition={'FACE_IDENTITY', 'PLACE_IDENTITY'};
ROIs = {'V1Left', 'V1Right', 'V2Left', 'V2Right', 'FFALeft', 'FFARight', 'PPALeft', 'PPARight', 'IFGLeft', 'IFGRight', 'mPFCLeft', 'mPFCRight', 'mPrecunLeft', 'mPrecunRight', 'OFALeft', 'OFARight', 'TPJLeft', 'TPJRight', 'SPLLeft', 'SPLRight', 'aIPSLeft', 'aIPSRight'};
ROIsize = 9; %3; %6; %
chance=1/4;
vividness_selection = 0;%1;%
vividness_target = 4;%3;
niter=100;
accuracyGroup=[];
pvals={};
%% N-fold cross-validation
%Remove bad runs
for iCond = 1:length(condition)
    for iSub=1:length(subList)
        if vividness_selection
            vividness_ratings = readtable('C:\Users\flavio.ragni\Google Drive Unitn\ERC_perceptual_awareness_resting_state_project\Results\fMRI\behavioral\rs_project_vividness_ratings.csv');
        end
        if vividness_selection
            [ds]=rs_project_makeds_mvpa_vividness_selection(subList,iSub,nRuns,char(condition(iCond)), vividness_ratings, vividness_target);
        else
            [ds]=rs_project_makeds_mvpa(subList,iSub,nRuns,char(condition(iCond)));
        end
        for iROI=1:length(ROIs)
            maskID=sprintf('%s_sphere%dmm_alignedMNI_3mm.nii.gz', char(ROIs(iROI)), ROIsize);
            ds_masked=cosmo_fmri_dataset(ds, 'mask', fullfile(pathtorois,maskID));
            %Function GTD_makeds_mvpa retun ds for currentSub already cleaned and
            %masked
            %Samples from a single chunk are used as test set, other chunks as
            %training set. Procedure repeated for all chunks.
            %Using measuers
            %Define which classifiers you want to use
            classifiers={@cosmo_classify_lda};
            %Print which classifiers are used
            nclassifiers=numel(classifiers);
            classifiers_names=cellfun(@func2str,classifiers,'UniformOutput',false);
            fprintf('\nUsing %d classifiers: %s in mask %s\n', nclassifiers,cosmo_strjoin(classifiers_names,','),maskID);
            %Create partitions
            p=cosmo_nfold_partitioner(ds_masked);
            p=cosmo_balance_partitions(p, ds_masked);
            %Make a copy of original dataset
            ds0=ds_masked;
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
             args.output='accuracy';
             measure=@cosmo_crossvalidation_measure;
             warning off
             %Run searchlight (without showing progress bar)
             perm_result{k,iROI} = measure(ds0,args);
             desc=sprintf('SUB%02d - LDA: accuracy %.1f%%', subList(iSub), perm_result{k,iROI}.samples*100)
             % save for every K (= nr iteration) a dataset result{k} with .sa .samples .fa .a of a
             % null distribution
             % save this, in every cell[100] a dataset
            end
            ds_masked= [];
        end
        save(fullfile(outputpath, sprintf('sub%02d_%s_LDA_LORO_permuted_rois.mat', subList(iSub), condition{iCond})),'perm_result')
    end
end
