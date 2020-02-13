function [ds]=rs_project_makeds_mvpa(subList,iSub,nRuns,condition)
%Define paths
pathtodata='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\alignedMNI_3mm\';
%pathtorois='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\rois\standard\';
pathtorois='\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\resting_state_project\mvpa\rois\OleggioCastello\alignedMNI\';
%Remove bad runs
if subList(iSub) == 7
    nRuns = 7;
    goodRuns = [1,2,3,4,5,6,7];
elseif subList(iSub) == 13
    nRuns = 8;
    goodRuns = [1,2,4,5,6,7,8,9];
end
for iRun=1:nRuns
    %Remove bad runs
    if subList(iSub) == 7
        iRun = goodRuns(iRun);
    elseif subList(iSub) == 13
        iRun = goodRuns(iRun);
    end
    switch condition
        case {'FACE_PLACE', 'FAMILIAR', 'FACE_PLACE_FAMILIARITY'}
            sprintf('Processing tstat for SUB%02d, RUN%02d',subList(iSub), iRun)
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2, tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
            case {'FACE_PLACE_FAMILIAR'}
            sprintf('Processing tstat for SUB%02d, RUN%02d',subList(iSub), iRun)
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            
            case {'FACE_PLACE_NONFAMILIAR'}
            sprintf('Processing tstat for SUB%02d, RUN%02d',subList(iSub), iRun)
            %Create temporary variables for each cope image of interest
            tempF1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
        case 'FACE'
            sprintf('Processing tstat for SUB%02d, RUN%02d',subList(iSub), iRun)
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[]; tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];            
            
        case 'PLACE'
            sprintf('Processing tstat for SUB%02d, RUN%02d',subList(iSub), iRun)
            %Create temporary variables for each cope image of interest
            tempP1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[]; tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
        case 'FACE_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2, tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];
            
        case 'PLACE_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempP1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2, tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
            
        case 'FACEFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempF1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat1_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat2_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat3_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat4_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_F1, tempF1_F2, tempF2_F1, tempF2_F2})'])
            tempF1_F1=[];tempF1_F2=[];tempF2_F1=[];tempF2_F2=[];
            
        case 'PLACEFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempP1_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat5_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat6_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat7_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_F2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat8_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_F1, tempP1_F2, tempP2_F1, tempP2_F2})'])
            tempP1_F1=[];tempP1_F2=[];tempP2_F1=[];tempP2_F2=[];
            
        case 'FACENONFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempF1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat9_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat10_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat11_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempF2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat12_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempF1_NF1, tempF1_NF2, tempF2_NF1, tempF2_NF2})'])
            tempF1_NF1=[];tempF1_NF2=[];tempF2_NF1=[];tempF2_NF2=[];
            
        case 'PLACENONFAMILIAR_IDENTITY'
            %Create temporary variables for each cope image of interest
            tempP1_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat13_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP1_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat14_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF1=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat15_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            tempP2_NF2=cosmo_fmri_dataset(fullfile(pathtodata,sprintf('SUB%02d_RUN%02d_tstat16_alignedMNI_3mm.nii.gz',subList(iSub),iRun)));
            %cosmo_disp(ds)
            genvarname('ds',num2str(iRun));
            %Stack them toghether for each RUN
            eval(['ds' num2str(iRun) '=cosmo_stack({tempP1_NF1, tempP1_NF2, tempP2_NF1, tempP2_NF2})'])
            tempP1_NF1=[];tempP1_NF2=[];tempP2_NF1=[];tempP2_NF2=[];
    end
end

switch condition
    %% Face/Place classification independent of familiarity:
    %  Train on two faces (1 familiar, 1 non familiar) and two places (1 familiar, 1 non familiar)
    %  and test on the 4 left out stimuli. Then do classification viceversa
    case 'FACE_PLACE'
        %Stack toghether ALL 9 RUNS
        if subList(iSub) == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subList(iSub) == 13
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
        targets=repmat(targets,nRuns,1);
        chunks=zeros((16*nRuns),1);
        for i=1:nRuns
            idxs=(i-1)*16+(1:16);
            chunks(idxs)=i;
        end
        labels=repmat({'Faces';'Places'},2,4)';
        labels=labels(:);
        labels=repmat(labels,nRuns,1);
        %Set modality for decoding: 1=1 fam and 1 non fam faces, 1 fam and 1 non fam places,
        %                           2 = 1 fam and 1 non fam faces, 1 fam and 1 non fam places
        stimType=zeros(144,1);
        stimType=repmat((1:2)',4,2)';
        stimType=stimType(:);
        stimType=repmat(stimType,nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
        
    case 'FACE_PLACE_FAMILIARITY'
        %Stack toghether ALL 9 RUNS
        if subList(iSub) == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subList(iSub) == 13
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
        targets=repmat(targets,nRuns,1);
        chunks=zeros((16*nRuns),1);
        for i=1:nRuns
            idxs=(i-1)*16+(1:16);
            chunks(idxs)=i;
        end
        labels=repmat({'Faces';'Places'},2,4)';
        labels=labels(:);
        labels=repmat(labels,nRuns,1);
        %Set modality for decoding: 1=2 fam faces, 2 fam places,
        %                           2 = 2 non fam faces, 2 non fam places
        stimType=zeros(144,1);
        stimType=repmat((1:2)',1,8)';
        stimType=stimType(:);
        stimType=repmat(stimType,nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
        
    case {'FACE_PLACE_FAMILIAR', 'FACE_PLACE_NONFAMILIAR'}
        %Stack toghether ALL 9 RUNS
        if subList(iSub) == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subList(iSub) == 13
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
        targets=repmat(targets,nRuns,1);
        chunks=zeros((8*nRuns),1);
        for i=1:nRuns
            idxs=(i-1)*8+(1:8);
            chunks(idxs)=i;
        end
        labels=repmat({'Faces';'Places'},1,4)';
        labels=labels(:);
        labels=repmat(labels,nRuns,1);
        %Set modality for decoding: 1=1 fam and 1 non fam faces, 1 fam and 1 non fam places,
        %                           2 = 1 fam and 1 non fam faces, 1 fam and 1 non fam places
        stimType=zeros(72,1);
        stimType=repmat((1:2)',2,2)';
        stimType=stimType(:);
        stimType=repmat(stimType,nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
         
    %% Familiarity classification WITHIN category:
    %  WHITHIN each category (face or place separately), train on one
    %  familiar and one non familiar stimuli, and test on the two left out.
    case {'FACE', 'PLACE'}
        %Stack toghether ALL 5 RUNS
        if subList(iSub) == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subList(iSub) == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Target 1 = Familiar; Target 2 = Non Familiar
        targets=repmat((1:2)',1,4)';
        targets=targets(:);
        targets=repmat(targets,nRuns,1);
        chunks=zeros((8*nRuns),1);
        for i=1:nRuns
            idxs=(i-1)*8+(1:8);
            chunks(idxs)=i;
        end
        %Set modality for decoding: 1=1 fam and 1 non fam (face OR place), 
        %                           2 = 1 fam and 1 non fam (face OR place)
        stimType=zeros(72,1);
        stimType=repmat((1:2)',2,2)';
        stimType=stimType(:);
        stimType=repmat(stimType,nRuns,1);
        labels=repmat({'Familiar';'Non Familiar'},1,4)';
        labels=labels(:);
        labels=repmat(labels,nRuns,1);
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
        if subList(iSub) == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subList(iSub) == 13
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
        targets=repmat(targets,nRuns,1);
        chunks=zeros((16*nRuns),1);
        for i=1:nRuns
            idxs=(i-1)*16+(1:16);
            chunks(idxs)=i;
        end
        labels=repmat({'Familiar';'Non Familiar'},1,8)';
        labels=labels(:);
        labels=repmat(labels,nRuns,1);
        %Set modality for decoding: 1=faces, 2 = places
        stimType=zeros(144,1);
        stimType=repmat((1:2)',2,4)';
        stimType=stimType(:);
        stimType=repmat(stimType,nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        ds.sa.stimType=stimType;
        
    case {'FACE_IDENTITY', 'PLACE_IDENTITY'}
        %Stack toghether ALL RUNS
        if subList(iSub) == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subList(iSub) == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Target 1 = Familiar; Target 2 = Non Familiar
        targets=repmat((1:4)',1,2)';
        targets=targets(:);
        targets=repmat(targets,nRuns,1);
        chunks=zeros((8*nRuns),1);
        for i=1:nRuns
            idxs=(i-1)*8+(1:8);
            chunks(idxs)=i;
        end
        if strcmp(condition, 'FACE_IDENTITY')
            labels=repmat({'Face1';'Face2';'Face3';'Face4'},1,2)';
        elseif strcmp(condition, 'PLACE_IDENTITY')
            labels=repmat({'Place1';'Place2';'Place3';'Place4'},1,2)';
        end
        labels=labels(:);
        labels=repmat(labels,nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
        
        case {'FACEFAMILIAR_IDENTITY', 'FACENONFAMILIAR_IDENTITY', 'PLACEFAMILIAR_IDENTITY', 'PLACENONFAMILIAR_IDENTITY'}
        %Stack toghether ALL 5 RUNS
        if subList(iSub) == 7
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7});
        elseif subList(iSub) == 13
            ds=cosmo_stack({ds1,ds2,ds4,ds5,ds6,ds7,ds8,ds9});
        else
            ds=cosmo_stack({ds1,ds2,ds3,ds4,ds5,ds6,ds7,ds8,ds9});
        end
        %Remove useless data in ds
        ds=cosmo_remove_useless_data(ds);
        %Target 1 = Familiar; Target 2 = Non Familiar
        targets=repmat((1:2)',1,2)';
        targets=targets(:);
        targets=repmat(targets,nRuns,1);
        chunks=zeros((4*nRuns),1);
        for i=1:nRuns
            idxs=(i-1)*4+(1:4);
            chunks(idxs)=i;
        end
        %Set modality for decoding: 1=1 fam and 1 non fam (face OR place), 
        %                           2 = 1 fam and 1 non fam (face OR place)
        labels=repmat({'Stim1';'Stim2'},1,2)';
        labels=labels(:);
        labels=repmat(labels,nRuns,1);
        ds.sa.targets=targets;
        ds.sa.chunks=chunks;
        ds.sa.labels=labels;
end

if subList(iSub) == 7
    ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];ds6=[];ds7=[];
elseif subList(iSub) == 13
    ds1=[];ds2=[];ds4=[];ds5=[];ds6=[];ds7=[];ds8=[];ds9=[];
else
    ds1=[];ds2=[];ds3=[];ds4=[];ds5=[];ds6=[];ds7=[];ds8=[];ds9=[];
end