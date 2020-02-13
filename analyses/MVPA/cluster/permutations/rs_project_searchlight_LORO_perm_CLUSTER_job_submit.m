%% A Sort of preamble
clear all;
matlab_version = sscanf(version('-release'),'%d%s');
addpath(genpath('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\LnifClusterFunctions'));
lnif_cluster = getLnifCluster('\\CIMEC-STORAGE\anglin\LINANG001QX2\flavio\matlab_pe','/home/flavio.ragni/matlab_pe');
job = lnif_cluster.createJob('Name','cosmo_searchlight');
job.AttachedFiles = {'rs_project_runsearchlight_LORO_perm_CLUSTER.m'};
%% Assign tasks using your function
subList=[1,3,5,6,7,9,10,11,12,13,14,15,16,17,18,20,21,22,23,24,25,27,28];
condition={'PLACE_IDENTITY'};%,'FACEFAMILIAR_IDENTITY','PLACEFAMILIAR_IDENTITY','PLACENONFAMILIAR_IDENTITY','FACENONFAMILIAR_IDENTITY','PLACE_IDENTITY','FAMILIAR','FACE_PLACE','PLACE','FACE'}
for iSub=1:length(subList)
    for iCond=1:length(condition)
        job.createTask(@rs_project_runsearchlight_LORO_perm_CLUSTER, 0,{subList(iSub), condition{iCond}});
    end
end
%% Run the analysis
job.Tasks
job.submit();
%job.wait();
%job.delete();
