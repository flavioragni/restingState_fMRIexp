%% MVPA test script
clear all
%Goal: import dataset from a single run, assign chunks, targets and labels.
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\alignedMNI_3mm\';
pathtorois='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\rois\OleggioCastello\alignedMNI\';
subList=[1,3,5,6,7,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,27,28];
nRuns=9;
%condition='FACE_PLACE_NONFAMILIAR';%'FACE_PLACE_FAMILIAR';%'FACE_PLACE';%'FAMILIAR';%'PLACE';%'FACE';%
condition={'FACE_PLACE', 'FACE', 'PLACE'};%{'FACE_PLACE_FAMILIARITY', 'FACE', 'FACE_PLACE', 'FACE_PLACE_FAMILIAR', 'FACE_PLACE_NONFAMILIAR', 'FAMILIAR', 'PLACE'};
%ROIs = {'SPL_7A_Thr50_3mm.nii.gz', 'aIPS_Thr20_3mm.nii.gz', 'FFA_Thr6_3mm.nii.gz', 'PPA_Thr5_3mm.nii.gz', 'V1_BA17_real_3mm.nii.gz'};
ROIs = {'V1Left', 'V1Right', 'V2Left', 'V2Right', 'FFALeft', 'FFARight', 'PPALeft', 'PPARight', 'IFGLeft', 'IFGRight', 'mPFCLeft', 'mPFCRight', 'mPrecunLeft', 'mPrecunRight', 'OFALeft', 'OFARight', 'TPJLeft', 'TPJRight', 'SPLLeft', 'SPLRight', 'aIPSLeft', 'aIPSRight'};
ROIsize = 9; %3; %6; %
chance=1/2;
vividness_selection = 0;%1;%
vividness_target = 4;%3;
accuracyGroup=[];
pvals={};
%% N-fold cross-validation
%Remove bad runs
for iCond=1:length(condition)
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
            %Function GTD_makeds_mvpa retun ds for currentSub already cleaned
            maskID=sprintf('%s_sphere%dmm_alignedMNI_3mm.nii.gz', char(ROIs(iROI)), ROIsize);
            %We mask it now to save time
            ds_masked=cosmo_fmri_dataset(ds, 'mask', fullfile(pathtorois,maskID));
            %Samples from a single chunk are used as test set, other chunks as
            %training set. Procedure repeated for all chunks.
            %Using measuers
            %Define which classifiers you want to use
            classifiers={@cosmo_classify_lda};
            If SVM is present use it
            if cosmo_check_external('svm',false)
                classifiers{end+1}=@cosmo_classify_libsvm;
            end
            %Print which classifiers are used
            nclassifiers=numel(classifiers);
            classifiers_names=cellfun(@func2str,classifiers,'UniformOutput',false);
            fprintf('\nUsing %d classifiers: %s in mask %s\n', nclassifiers,cosmo_strjoin(classifiers_names,','),maskID);
            %Set measures
            measure=@cosmo_crossvalidation_measure;
            args=struct();
            args.partitions=cosmo_nchoosek_partitioner(ds_masked,1,'stimType',[]);%Test in both directions
            args.partitions=cosmo_balance_partitions(args.partitions,ds_masked);
            args.output='predictions';
            
            %RUN CLASSIFICATIONS - Compute accuracy predictions for each classifier
            for k=1:nclassifiers
                %Set the classifier
                args.classifier=classifiers{k};
                %Apply features selection
                %args.classifier=@cosmo_classify_meta_feature_selection;
                switch k
                    case 1
                        args.child_classifier=@cosmo_classify_lda;
                    case 2
                        args.child_classifier=@cosmo_classify_libsvm;
                end
                %Compute prediction using the measure
                predicted_ds=measure(ds_masked,args);
                %Compute confusion matrix
                confusion_matrix=cosmo_confusion_matrix(predicted_ds);
                %Compute accuracy and store it in variable accuracy
                sum_diag=sum(diag(confusion_matrix));
                sum_total=sum(confusion_matrix(:));
                accuracy=sum_diag/sum_total;
                
                %Store accuracy in a group variable - column 1 LDA, column 2 SVM
                accuracyGroup(iSub,k,iROI)=accuracy;
                
                classifier_name=strrep(classifiers_names{k},'_',' '); %No underscores
                desc=sprintf('SUB%02d - %s: accuracy %.1f%%', subList(iSub), classifier_name, accuracy*100);
                
                %Print classification accuracy in terminal window
                fprintf('%s\n',desc);
            end
            ds_masked = [];
        end
        ds=[];
    end

    %Compute group level statistic
    %Subtract from accuracy chance level and store it in a new variable
    accuracyCorr=accuracyGroup-chance;
    %Do t-test against 0
    for iROI=1:length(ROIs)
        for k=1:nclassifiers
            [h,p,ci,stats]=ttest(accuracyCorr(:,k,iROI));
            pvals{iROI,k}=sprintf(['classification accuracy in %s at group level:'...
                '%.3f +/- %.3f, t_%d=%.3f, p=%.5f (using %s)\n'], char(ROIs(iROI)),mean(accuracyGroup(:,k,iROI)),std(accuracyGroup(:,k,iROI)),stats.df,stats.tstat,p,classifiers_names{k});
        end
    end
    %Export accuracy in Excel
    if vividness_selection
        for iROI=1:length(ROIs)
            xlswrite(sprintf('accuracyGroup_%s_sphere%d_MVPA_N=%d_nchoosek_leaveOneRunOut_vividness=%d.xls',char(condition(iCond)), ROIsize, length(subList), vividness_target), accuracyGroup(:,:,iROI),iROI);
        end
        xlswrite(sprintf('accuracyGroup_%s_sphere%d_MVPA_N=%d_nchoosek_leaveOneRunOut_vividness=%d.xls',char(condition(iCond)), ROIsize, length(subList), vividness_target), accuracyGroup(:,:,iROI),'pvals');
    else
        for iROI=1:length(ROIs)
            xlswrite(sprintf('accuracyGroup_%s_sphere%d_MVPA_N=%d_nchoosek_leaveOneRunOut.xls',char(condition(iCond)), ROIsize, length(subList)), accuracyGroup(:,:,iROI),iROI);
        end
        xlswrite(sprintf('accuracyGroup_%s_sphere%d_MVPA_N=%d_nchoosek_leaveOneRunOut.xls',char(condition(iCond)), ROIsize, length(subList)), pvals,'pvals');
    end
    save(sprintf('accuracyGroup_%s_sphere%d_MVPA_N=%d_nchoosek_leaveOneRunOut.mat',char(condition(iCond)), ROIsize, length(subList)), 'accuracyGroup');
    pvals={};
end