clear all;
%Define variables
pathtodata='/mnt/raidVol2/flavio.ragni/resting_state_project/mvpa/alignedMNI_3mm/';
pathtorois='/mnt/raidVol2/flavio.ragni/resting_state_project/rois/OleggioCastello/alignedMNI/';
pathtoperm='/mnt/raidVol2/flavio.ragni/resting_state_project/mvpa/permutations/single_sub_permutations';
addpath(genpath('/mnt/raidVol2/flavio.ragni/toolbox/CoSMoMVPA-master/'));
subList=[1,3,5,6,7,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,27,28];
ROIs = {'V1Left', 'V1Right', 'FFALeft', 'FFARight', 'PPALeft', ...
        'PPARight', 'IFGLeft', 'IFGRight', 'mPFCLeft', 'mPFCRight', ...
        'mPrecunLeft', 'mPrecunRight', 'TPJLeft', 'TPJRight', ...
        'SPLLeft', 'SPLRight', 'aIPSLeft', 'aIPSRight'};
ROIs_index = [1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 17, 18, 19, 20, 21, 22];
nRuns=9;
condition= {'FACE_IDENTITY', 'PLACE_IDENTITY', 'FACE_PLACE', 'FACE', 'PLACE'};
niter=10000;
%% 1. Load real dataset
group_facePlace = load('accuracyGroup_FACE_PLACE_sphere9_MVPA_N=23_nchoosek_leaveOneRunOut_LDA.mat');
group_faceIdentity = load('accuracyGroup_FACE_IDENTITY_sphere9_MVPA_N=23_regular_leaveOneRunOut_LDA.mat');
group_placeIdentity = load('accuracyGroup_PLACE_IDENTITY_sphere9_MVPA_N=23_regular_leaveOneRunOut_LDA.mat');
group_face = load('accuracyGroup_FACE_sphere9_MVPA_N=23_nchoosek_leaveOneRunOut_LDA.mat');
group_place = load('accuracyGroup_PLACE_sphere9_MVPA_N=23_nchoosek_leaveOneRunOut_LDA.mat');
%% 2. Prepare matrix with group average for each ROI and condition
% Matrix = ROI1con1, ROI1cond2, ROI1cond3 ...
%ROIs order: V1 Left, V1 Right, FFA Left, FFA Right, PPA Left, PPA Right
%            IFG Left, IFG Right, mPFC Left, mPFC Right, Precun Left,
%            Precun Right, TPJ Left, TPJ Right, SPL Left, SPL Right,
%            aIPS Left, aIPS Right
%Conditions order: faceID, placeID, facePlace, face, place
group_average_all = zeros(length(condition),length(ROIs));
for i = 1:length(ROIs)
    group_average_all(1,i) = mean(group_faceIdentity.accuracyGroup(:,ROIs_index(i)));
    group_average_all(2,i) = mean(group_placeIdentity.accuracyGroup(:,ROIs_index(i)));
    group_average_all(3,i) = mean(group_facePlace.accuracyGroup(:,ROIs_index(i)));
    group_average_all(4,i) = mean(group_face.accuracyGroup(:,ROIs_index(i)));
    group_average_all(5,i) = mean(group_place.accuracyGroup(:,ROIs_index(i)));
end
%Save averaged group data
save('group_average_all_real.mat', 'group_average_all');
%% 3. Create 10000 group average values based on permutations
%Preallocate signesub permutations (NXcond matrix)
permSub=cell(length(subList),length(condition));
for iSub = 1:length(subList)
    for iCond = 1:length(condition)
        load(fullfile(pathtoperm,sprintf('sub%02d_%s_LDA_LORO_permuted_rois.mat', subList(iSub), condition{iCond})));
        permSub{iSub, iCond} = perm_result;
        perm_result=[];
    end
end
save('single_sub_perm.mat','permSub');
%Load single subject permutations (Nxcond matrix)
load('single_sub_perm.mat');
%Preallocate space for average accuracies
group_average_permuted = cell(length(condition),length(ROIs));
%Inside each cell I will store 10000 group accuracy values computed by
%randomly picking single sub permuted accuracy values
cond = length(condition);
sub = length(subList);
parfor i = 1:length(ROIs)
    %Avoid that rand starts with the same numbers after all parfors
    rng('shuffle');
    for j = 1:cond
        for k = 1:niter
            tempAcc=zeros(sub,1);
            for m = 1:sub
                %Pick one random accuracy value for each subject
                tempAcc(m,1) = permSub{m,j}{randi(100,1),ROIs_index(i)}.samples;
            end
            group_average_permuted{j,i}=[group_average_permuted{j,i}; mean(tempAcc)];
        end
    end
end
save('group_average_all_permuted.mat', 'group_average_permuted');
%% Step 4. For each factorial combination of ROI and condition, find where real accuracy falls in the null dist
% For understand where real accuracy stored in group_average_all
% falls with respect to the 10000 permuted accuracy values stored in
% group_average_permuted

%Load real accuracies
load('group_average_all_real.mat');
%Load permuted accuracies
load('group_average_all_permuted.mat');
%Preallocate space for p-values
group_p = zeros(length(condition), length(ROIs));

%Find where real accuracy value in group_average_all fall with respect to
%group_average_permuted
for i = 1:length(ROIs)
    for j = 1:length(condition)
        group_p(j,i)=sum(group_average_permuted{j,i}>group_average_all(j,i))/niter;
    end
end
save('group_p_uncorr.mat', 'group_p');
%% Step 5. Compute FDR correction on p-values
%Load p-values
load('group_p_uncorr.mat');
%Compute fdr correction on p-values
[group_fdr, crit_p, adj_ci_cvrg, adj_p]=fdr_bh(group_p,0.05,'pdep','yes');
save('group_permuted_fdr.mat', 'group_fdr');
%% Step 6. Plot group accuracy with statistical significance and FDR corr
%First plot identity decoding (chance=1/4)
load('group_p_uncorr.mat');
load('group_average_all_real.mat');
load('group_permuted_fdr.mat');
index=[1:2:length(ROIs)];
titles={'V1', 'FFA', 'PPA', 'IFG', 'mPFC', 'mPrecun', 'TPJ', 'SPL', 'aIPS'};
figure
for i=1:length(index)
    subplot(fix(length(index)/3), 3, i)
    bar([group_average_all(1,index(i)), group_average_all(2,index(i)), group_average_all(1,index(i)+1), group_average_all(2,index(i)+1)]);
    hold on
    plot(xlim,[1/4 1/4], 'r');
    hold on;
    sem=[std(group_faceIdentity.accuracyGroup(:,ROIs_index(i)))/sqrt(length(subList)), ...
       std(group_placeIdentity.accuracyGroup(:,ROIs_index(i)))/sqrt(length(subList)); ...
       std(group_faceIdentity.accuracyGroup(:,ROIs_index(i+1)))/sqrt(length(subList)), ...
       std(group_placeIdentity.accuracyGroup(:,ROIs_index(i+1)))/sqrt(length(subList))];
    er=errorbar([0.85,1.14;1.85,2.14],group_average_all(1:2,index(i):index(i)+1), ...
        sem, sem, 'Color', [0 0 0], 'LineStyle', 'none');
    title(titles{i});
    ylim([0 0.6]);
    xticklabels({'Left', 'Right'});
    
    %Set significance
    if group_fdr(1,index(i))==1
        if group_p(1,index(i))<0.001
            text(0.82, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(1,index(i))<0.01
            text(0.82, 0.45, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(1,index(i))<0.05
            text(0.82, 0.45, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
    else
        if group_p(1,index(i))<0.001
            text(0.82, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(1,index(i))<0.01
            text(0.82, 0.45, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(1,index(i))<0.05
            text(0.82, 0.45, sprintf('%s', '*'),'FontSize', 14)
        end
    end
    if group_fdr(2,index(i))==1
        if group_p(2,index(i))<0.001
            text(1.12, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(2,index(i))<0.01
            text(1.12, 0.45, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(2,index(i))<0.05
            text(1.12, 0.45, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
    else
        if group_p(2,index(i))<0.001
            text(1.12, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(2,index(i))<0.01
            text(1.12, 0.45, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(2,index(i))<0.05
            text(1.12, 0.45, sprintf('%s', '*'),'FontSize', 14)
        end
    end
    if group_fdr(1,index(i)+1)==1
        if group_p(1,i+1)<0.001
            text(1.82, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(1,index(i)+1)<0.01
            text(1.82, 0.45, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(1,index(i)+1)<0.05
            text(1.82, 0.45, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
    else
        if group_p(1,index(i)+1)<0.001
            text(1.82, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(1,index(i)+1)<0.01
            text(1.82, 0.45, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(1,index(i)+1)<0.05
            text(1.82, 0.45, sprintf('%s', '*'),'FontSize', 14)
        end
    end
    if group_fdr(2,index(i)+1)==1
        if group_p(2,index(i)+1)<0.001
            text(2.11, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(2,index(i)+1)<0.01
            text(2.11, 0.45, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(2,index(i)+1)<0.05
            text(2.11, 0.45, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
    else
        if group_p(2,index(i)+1)<0.001
            text(2.11, 0.45, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(2,index(i)+1)<0.01
            text(2.11, 0.45, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(2,index(i)+1)<0.05
            text(2.11, 0.45, sprintf('%s', '*'),'FontSize', 14)
        end
    end
end
legend('Face Identity', 'Place Identity', 'Chance Level');

%First plot nchoosek decoding (chance=1/2)
figure
for i=1:length(index)
    subplot(fix(length(index)/3), 3, i)
    bar([group_average_all(3,index(i)), group_average_all(4,index(i)), group_average_all(5,index(i)), group_average_all(3,index(i)+1), group_average_all(4,index(i)+1), group_average_all(5,index(i)+1)]);
    hold on
    plot(xlim,[1/2 1/2], 'r');
    hold on;
    sem=[std(group_facePlace.accuracyGroup(:,ROIs_index(i)))/sqrt(length(subList)), ...
        std(group_face.accuracyGroup(:,ROIs_index(i)))/sqrt(length(subList))...
        std(group_place.accuracyGroup(:,ROIs_index(i)))/sqrt(length(subList)); ...
        std(group_facePlace.accuracyGroup(:,ROIs_index(i+1)))/sqrt(length(subList)), ...
        std(group_face.accuracyGroup(:,ROIs_index(i+1)))/sqrt(length(subList)),...
        std(group_placeIdentity.accuracyGroup(:,ROIs_index(i+1)))/sqrt(length(subList))];
    er=errorbar([0.78,1, 1.22;1.78,2,2.22],group_average_all(3:end,index(i):index(i)+1)', ...
        sem, sem, 'Color', [0 0 0], 'LineStyle', 'none');
    title(titles{i});
    ylim([0.4 1]);
    xticklabels({'Left', 'Right'});
    
    %Set significance
    if group_fdr(3,index(i))==1
        if group_p(3,index(i))<0.001
            text(0.78, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(3,index(i))<0.01
            text(0.78, 0.85, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(3,index(i))<0.05
            text(0.78, 0.85, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
    else
        if group_p(3,index(i))<0.001
            text(0.78, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(3,index(i))<0.01
            text(0.78, 0.85, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(3,index(i))<0.05
            text(0.78, 0.85, sprintf('%s', '*'),'FontSize', 14)
        end
    end
     if group_fdr(4,index(i))==1 
        if group_p(4,index(i))<0.001
            text(1, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(4,index(i))<0.01
            text(1, 0.85, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(4,index(i))<0.05
            text(1, 0.85, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
     else
        if group_p(4,index(i))<0.001
            text(1, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(4,index(i))<0.01
            text(1, 0.85, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(4,index(i))<0.05
            text(1, 0.85, sprintf('%s', '*'),'FontSize', 14)
        end
     end
     if group_fdr(5,index(i))==1
        if group_p(5,index(i))<0.001
            text(1.22, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(5,index(i))<0.01
            text(1.22, 0.85, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(5,index(i))<0.05
            text(1.22, 0.85, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
     else
        if group_p(5,index(i))<0.001
            text(1.22, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(5,index(i))<0.01
            text(1.22, 0.85, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(5,index(i))<0.05
            text(1.22, 0.85, sprintf('%s', '*'),'FontSize', 14)
        end
     end
     if group_fdr(3,index(i)+1)==1
        if group_p(3,index(i)+1)<0.001
            text(1.78, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(3,index(i)+1)<0.01
            text(1.78, 0.85, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(3,index(i)+1)<0.05
            text(1.78, 0.85, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
     else
        if group_p(3,index(i)+1)<0.001
            text(1.78, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(3,index(i)+1)<0.01
            text(1.78, 0.85, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(3,index(i)+1)<0.05
            text(1.78, 0.85, sprintf('%s', '*'),'FontSize', 14)
        end
     end
     if group_fdr(4,index(i)+1)==1
        if group_p(4,index(i)+1)<0.001
            text(2, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(4,index(i)+1)<0.01
            text(2, 0.85, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(4,index(i)+1)<0.05
            text(2, 0.85, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
     else
        if group_p(4,index(i)+1)<0.001
            text(2, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(4,index(i)+1)<0.01
            text(2, 0.85, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(4,index(i)+1)<0.05
            text(2, 0.85, sprintf('%s', '*'),'FontSize', 14)
        end
     end
     if group_fdr(5,index(i)+1)==1
        if group_p(5,index(i)+1)<0.001
            text(2.22, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(5,index(i)+1)<0.01
            text(2.22, 0.85, sprintf('%s\n%s', '*', '*'),'color','red','FontSize', 14)
        elseif group_p(5,index(i)+1)<0.05
            text(2.22, 0.85, sprintf('%s', '*'),'color','red','FontSize', 14)
        end
     else   
        if group_p(5,index(i)+1)<0.001
            text(2.22, 0.85, sprintf('%s\n%s\n%s', '*', '*', '*'),'FontSize', 14)
        elseif group_p(5,index(i)+1)<0.01
            text(2.22, 0.85, sprintf('%s\n%s', '*', '*'),'FontSize', 14)
        elseif group_p(5,index(i)+1)<0.05
            text(2.22, 0.85, sprintf('%s', '*'),'FontSize', 14)
        end
    end
end
legend('Face vs Place', 'Face Familiarity', 'Place Familiarity', 'Chance Level');
