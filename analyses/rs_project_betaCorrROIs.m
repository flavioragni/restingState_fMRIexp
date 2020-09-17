clear all;
%% rs_project_betaCorrROIs
%Compute for each ROI the spearman ranked correlation between Beta values
%and vividness ratings

%% Define variables
pathtodata='/mnt/raidVol2/flavio.ragni/resting_state_project/mvpa/alignedMNI_3mm/beta/';
pathtorois='/mnt/raidVol2/flavio.ragni/resting_state_project/rois/OleggioCastello/alignedMNI/';
pathtolog='/mnt/raidVol2/flavio.ragni/resting_state_project/raw_data/log/';
addpath(genpath('/mnt/raidVol2/flavio.ragni/toolbox/CoSMoMVPA-master/'));
subList=[1,3,5,6,7,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,27,28];
ROIs = {'V1Left', 'V1Right', 'FFALeft', 'FFARight', 'PPALeft', ...
    'PPARight', 'IFGLeft', 'IFGRight', 'mPFCLeft', 'mPFCRight', ...
    'mPrecunLeft', 'mPrecunRight', 'TPJLeft', 'TPJRight', ...
    'SPLLeft', 'SPLRight', 'aIPSLeft', 'aIPSRight'};
nRuns = 9;
rhoSub = zeros(length(subList), length(ROIs));
pvalSub = zeros(length(subList), length(ROIs));
fisherZ = zeros(length(subList), length(ROIs));
verbose = 0;
%% Part 1: compute spearman correlation between betas and vividness within each ROI for each SUB
for iSub = 1:length(subList)
    %% Step 1: create SUB dataset; matrix with betas for all trials stacked
    ds = rs_project_makeds_betaCorr(subList,iSub,nRuns)
    %% Step 2: create vector with vividness ratings
    vividRat = [];
    if subList(iSub) == 7
        nRunsSub = 7;
        goodRuns = [1,2,3,4,5,6,7];
    elseif subList(iSub) == 13
        nRunsSub = 8;
        goodRuns = [1,2,4,5,6,7,8,9];
    else
        nRunsSub = 9;
    end
    for iRun = 1:nRunsSub
        %Remove bad runs
        if subList(iSub) == 7
            iRun = goodRuns(iRun);
        elseif subList(iSub) == 13
            iRun = goodRuns(iRun);
        end
        %Load ratings
        load(fullfile(pathtolog, sprintf('SUB%02d_RUN%02d_rs_log.mat', subList(iSub), iRun)));
        vividRatTemp = trial_struct(:,6);
        vividRat = [vividRat; vividRatTemp];
        trial_struct = []; vividRatTemp = [];
    end
    %Remove trials with no ratings
    ds.samples(vividRat==0, :) = []; ds.sa.targets(vividRat==0) = []; ds.sa.chunks(vividRat==0) = []; ds.sa.labels(vividRat==0) = [];
    vividRat(vividRat==0) = [];
    %% Step 4: mask the dataset with ROI and average Betas
    figure()
    for iROI = 1:length(ROIs)
        %Mask the dataset
        maskID=sprintf('%s_sphere9mm_alignedMNI_3mm.nii.gz', char(ROIs(iROI)));
        ds_masked=cosmo_fmri_dataset(ds, 'mask', fullfile(pathtorois,maskID));
        %Average Betas within ROI
        avgBetas = mean(ds_masked.samples,2);
        %% Step 5: compute Spearman correlation and store result
        %Check dimensionality ratings and Betas agrees
        if size(avgBetas)~= size(vividRat)
            error('Error! \nVividness ratings and trials dimensions do not agree!')
        end
        %Compute the correlation
        [rho, pval] = corr(avgBetas, vividRat, 'type', 'Spearman');
        %Print result
        if verbose
            fprintf('SUB%02d correlation in %s : %.4f, p = %.4f\n', subList(iSub), char(ROIs(iROI)), rho, pval)
        end
        %Plot betas and vividness
        scatter(vividRat,avgBetas)
        title(ROIs{iROI})
        saveas(gcf, sprintf('plots/SUB%02d_%s_correlation.png', subList(iSub), ROIs{iROI}));
        close()
        %Store rho and pval
        rhoSub(iSub, iROI) = rho;
        pvalSub(iSub, iROI) = pval;
        rho = []; pval = []; avgBetas = [];
    end  
end
%% Part 2: apply Fisher transform to rho values separately for each ROI
for iROI = 1:length(ROIs)
    fisherZ(:,iROI) = atanh(rhoSub(:,iROI));
    %Plot coeff distribution and Z distribution
    if verbose
        figure()
        subplot(2,1,1)
        histogram(rhoSub(:,iROI))
        xlabel('Spearman rho')
        title(sprintf('%s: Distribution of correlation coefficients', ROIs{iROI}))
        subplot(2,1,2)
        histogram(fisherZ(:,iROI))
        xlabel('Fisher z')
        title(sprintf('%s: Distribution of z-scores', ROIs{iROI}))
    end
end
%% Part 3: compute group level statistic on z-scores
for iROI = 1:length(ROIs)
    [h,p,ci,stats]=ttest(fisherZ(:,iROI));
    fprintf(['Correlation between betas and vividness in %s at group level:'...
        '%.3f +/- %.3f, t_%d=%.3f, p=%.5f\n'], char(ROIs(iROI)),mean(fisherZ(:,iROI)),std(fisherZ(:,iROI)),stats.df,stats.tstat,p);
end