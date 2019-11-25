function [trial_struct] = run_rs_project(subNum, runNum)
Cfg=struct;
isdebug = 1;
%% Define paths
Cfg.path.cue = sprintf('C:\\Users\\flavio.ragni\\Google Drive Unitn\\Resting state project\\Scripts\\fMRI\\Audio\\SUB%02d\\', subNum);
Cfg.path.trd = 'C:\Users\flavio.ragni\Google Drive\Resting state project\Scripts\trd\';
Cfg.path.save = 'C:\Users\flavio.ragni\Google Drive\Resting state project\Scripts\log\';
%% Define variables
Cfg.ExpInfo.trialNum=16;
Cfg.ExpInfo.StimSize = 90;
%% Define audio settings
Cfg.audio.nrchannels = 2;
Cfg.audio.freq = 48000;
Cfg.audio.cues = {'1.wav', '2.wav', '3.wav', '4.wav', '5.wav', '6.wav', '7.wav', '8.wav'};
%Codes: 1 = Fam Face1; 2 = Fam Face 2; 3 = Fam Place 1; 4 = Fam Place2
%5 = Non Fam Face 1; 6 = Non Fam Face 2; 7 = Non Fam Place 1; 8 = Non Fam
%Place 2
%% Define buttons for behavioral response
Cfg.ExpInfo.button_press.buttons = KbName({'1!', '2@', '3#', '4$'});
Cfg.ExpInfo.button_press.trigger = KbName({'5%'});
%% Define timing
Cfg.timing.baseline_1=12;
Cfg.timing.cue=1;
Cfg.timing.img_delay=4;
Cfg.timing.rating=2;
Cfg.timing.ITI=10;
Cfg.timing.baseline_2=20;
%% Initialize screen
HideCursor();
screens = Screen('Screens');
screenNumber = max(screens);
% Screen_res = [1280 1024];
% Screen('Resolution', screenNum, Screen_res(1), Screen_res(2), 60, 32);
%
% screenNum = max(Screen('Screens'));
% oldres = Screen('Resolution',screenNum);
% if ~isempty(screen_res) & ~isequal([oldres.width oldres.height], screen_res, 10)
%     Screen('Resolution',screenNum,screen_res(1),screen_res(2));
% end

PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UseDataPixx');
if isdebug
    [w, wRect] = Screen('OpenWindow', screenNumber, [40 40 40],[0 0 640 480]);
else
    [w, wRect] = Screen('OpenWindow', screenNumber, [40 40 40],[0 0 1920 1200]);
end
%% Define rectangles position
%Get center screen position
Cfg.screen.CX=wRect(3)/2;
Cfg.screen.CY=wRect(4)/2;

% parameters of rectangle during the imagery delay
Cfg.screen.color_rect = [0 0 0];
Cfg.screen.points_rect = [Cfg.screen.CX-Cfg.ExpInfo.StimSize*1.05,Cfg.screen.CY-Cfg.ExpInfo.StimSize*1.05,Cfg.screen.CX+Cfg.ExpInfo.StimSize*1.05,Cfg.screen.CY+Cfg.ExpInfo.StimSize*1.05];
Cfg.screen.pen_width = 3;
Cfg.screen.pen_width_rect = 5;
Cfg.screen.pen_width_scale = 5;
Cfg.screen.points_rect2 = [Cfg.screen.CX-238,Cfg.screen.CY-55,Cfg.screen.CX+238,Cfg.screen.CY+55];

%for the rating scale
Cfg.screen.vividness_color = [0 0 0];
Cfg.screen.vividness_fromH = Cfg.screen.CX-240;
Cfg.screen.vividness_fromV  = Cfg.screen.CY+50;
Cfg.screen.vividness_toH   = Cfg.screen.CX+240;
Cfg.screen.vividness_toV = Cfg.screen.CY+50;
Cfg.screen.rate(1).text = '1';
Cfg.screen.rate(2).text = '2';
Cfg.screen.rate(3).text = '3';
Cfg.screen.rate(4).text = '4';
Cfg.screen.vividness_rate.text = 'How vividly did you imagine the stimulus?';
Cfg.screen.pos_rate_instr = [Cfg.screen.CX Cfg.screen.CY-100 Cfg.screen.CX Cfg.screen.CY-100];

%for the trigger
Cfg.screen.trigger_color = [0 0 0];
Cfg.screen.trigger_fromH = Cfg.screen.CX-240;
Cfg.screen.trigger_fromV  = Cfg.screen.CY+50;
Cfg.screen.trigger_toH   = Cfg.screen.CX+240;
Cfg.screen.trigger_toV = Cfg.screen.CY+50;
Cfg.screen.trigger.pos = [Cfg.screen.CX Cfg.screen.CY-100 Cfg.screen.CX Cfg.screen.CY-100];
Cfg.screen.trigger.text = 'Waiting for scanner trigger...';

%position of the numbers on the scale
Cfg.screen.pos_rate1 = [Cfg.screen.CX-240 Cfg.screen.CY+80 Cfg.screen.CX-240 Cfg.screen.CY+90];
Cfg.screen.pos_rate2 = [Cfg.screen.CX-80 Cfg.screen.CY+80 Cfg.screen.CX-80 Cfg.screen.CY+90];
Cfg.screen.pos_rate3 = [Cfg.screen.CX+80 Cfg.screen.CY+80 Cfg.screen.CX+80 Cfg.screen.CY+90];
Cfg.screen.pos_rate4 = [Cfg.screen.CX+240 Cfg.screen.CY+80 Cfg.screen.CX+240 Cfg.screen.CY+90];
%% Define central cross
Cfg.screen.sizecross=6;
Cfg.screen.cross=[Cfg.screen.CX-Cfg.screen.sizecross/2 Cfg.screen.CY-Cfg.screen.sizecross*2 Cfg.screen.CX+Cfg.screen.sizecross/2 Cfg.screen.CY+Cfg.screen.sizecross*2; Cfg.screen.CX-Cfg.screen.sizecross*2 Cfg.screen.CY-Cfg.screen.sizecross/2 Cfg.screen.CX+Cfg.screen.sizecross*2 Cfg.screen.CY+Cfg.screen.sizecross/2]';
%% Load auditory cues: preallocate space and avoid to load them during the trial
[waveform_cue_one, Fs_cue_one] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{1}));
[waveform_cue_two, Fs_cue_two] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{2}));
[waveform_cue_three, Fs_cue_three] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{3}));
[waveform_cue_four, Fs_cue_four] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{4}));
[waveform_cue_five, Fs_cue_five] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{5}));
[waveform_cue_six, Fs_cue_six] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{6}));
[waveform_cue_seven, Fs_cue_seven] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{7}));
[waveform_cue_eight, Fs_cue_eight] = audioread(fullfile(Cfg.path.cue, Cfg.audio.cues{8}));
waveform_cues = {waveform_cue_one, waveform_cue_two, waveform_cue_three, waveform_cue_four, waveform_cue_five, waveform_cue_six, waveform_cue_seven, waveform_cue_eight};
Fs_cues = {Fs_cue_one, Fs_cue_two, Fs_cue_three, Fs_cue_four, Fs_cue_five, Fs_cue_six, Fs_cue_seven, Fs_cue_eight};
%% Initialize Trial Structure
%load file for specific subject and run
load(fullfile(Cfg.path.trd, sprintf('SUB%02d_RUN%02d_rs', subNum, runNum)));
%% Start the task
% Initialize Sounddriver
InitializePsychSound(1);

%Wait for scanner trigger
trigger=1;
while(trigger)
    DrawFormattedText(w,  Cfg.screen.trigger.text, 'center', 'center',[],[],[],[],[],[],Cfg.screen.trigger.pos);
    Screen('Flip', w);
    [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
    if keyCode(Cfg.ExpInfo.button_press.trigger) == 1
        trigger=0;
    end
end

%Phase 1: Baseline 1
Screen('FrameRect', w, Cfg.screen.color_rect, Cfg.screen.points_rect , Cfg.screen.pen_width);
Screen('FillRect', w,[0 0 0],Cfg.screen.cross);
%Get flip time and save it in trial_struct
Screen('Flip', w);
time_start=GetSecs;
WaitSecs(Cfg.timing.baseline_1);

%Start of trials
for k = 1: Cfg.ExpInfo.trialNum

    %Phase 2: Cue
    Screen('FrameRect', w, Cfg.screen.color_rect, Cfg.screen.points_rect , Cfg.screen.pen_width);
    Screen('FillRect', w,[0 0 0],Cfg.screen.cross);
    %Select correct cue based on trial code
    %Select correct cue based on trial code
    waveform = waveform_cues{trial_struct(k,1)};
    Fs = Fs_cues{trial_struct(k,1)};
    Cfg.audio.nrchannels = size(waveform, 2);
    % Open Psych-Audio port, with the follow arguements
    pahandle = PsychPortAudio('Open', [], 1, 1, Fs, Cfg.audio.nrchannels);
    % Fill the audio playback buffer with the audio data, doubled for stereo
    % presentation
    PsychPortAudio('FillBuffer', pahandle, waveform');
    % Starts sound immediatley
    PsychPortAudio('Start', pahandle, 1);
    Screen('Flip', w);
    time_cue = GetSecs;
    WaitSecs(Cfg.timing.cue);
    %Get flip time and save it in trial_struct
    trial_struct(k,2) = time_cue-time_start;
    %Close psychportAudio
    PsychPortAudio('Stop', pahandle);
    
    %Phase 3: Imagery delay
    Screen('FrameRect', w, Cfg.screen.color_rect, Cfg.screen.points_rect , Cfg.screen.pen_width);
    Screen('FillRect', w,[0 0 0],Cfg.screen.cross);
    Screen('Flip', w);
    time_delay = GetSecs;
    WaitSecs(Cfg.timing.img_delay);
    %Get flip time and save it in trial_struct
    trial_struct(k,3) = time_delay-time_start;
    
    %Phase 4: Vividness Rating & Response collection
    DrawFormattedText(w,  Cfg.screen.vividness_rate.text, 'center', 'center',[],[],[],[],[],[],Cfg.screen.pos_rate_instr);
    DrawFormattedText(w,  Cfg.screen.rate(1).text, 'center', 'center',[],[],[],[],[],[],Cfg.screen.pos_rate1);
    DrawFormattedText(w,  Cfg.screen.rate(2).text, 'center', 'center',[],[],[],[],[],[],Cfg.screen.pos_rate2);
    DrawFormattedText(w,  Cfg.screen.rate(3).text, 'center', 'center',[],[],[],[],[],[],Cfg.screen.pos_rate3);
    DrawFormattedText(w,  Cfg.screen.rate(4).text, 'center', 'center',[],[],[],[],[],[],Cfg.screen.pos_rate4);
    Screen('Flip', w);
    time_rating = GetSecs;
    %Collect response. For the scanner, button box correspond to numbers
    %from 1 to 4
    %Loop KbCheck untill you have a button press
    while (GetSecs-time_rating) < Cfg.timing.rating
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        if sum(keyCode)>0
            if keyCode(Cfg.ExpInfo.button_press.buttons(1)) == 1
                trial_struct(k,6) = 1;
                trial_struct(k,7) =  secs - time_rating;
            elseif keyCode(Cfg.ExpInfo.button_press.buttons(2)) == 1
                trial_struct(k,6) = 2;
                trial_struct(k,7) =  secs - time_rating;
            elseif keyCode(Cfg.ExpInfo.button_press.buttons(3)) == 1
                trial_struct(k,6) = 3;
                trial_struct(k,7) =  secs - time_rating;
            elseif keyCode(Cfg.ExpInfo.button_press.buttons(4)) == 1
                trial_struct(k,6) = 4;
                trial_struct(k,7) = secs - time_rating;
            end
        end
    end
    
    %Get flip time and save it in trial_struct
    trial_struct(k,4) = time_rating-time_start;
    
    %Phase 5: Inter Trial Interval (ITI)
    if k == 16
        break
    else
        Screen('FrameRect', w, Cfg.screen.color_rect, Cfg.screen.points_rect , Cfg.screen.pen_width);
        Screen('FillRect', w,[0 0 0],Cfg.screen.cross);
        Screen('Flip', w);
        time_ITI = GetSecs;
        WaitSecs(Cfg.timing.ITI);
        %Get flip time and save it in trial_struct
        trial_struct(k,5) = time_ITI-time_start;
    end
end

%Phase 6: Baseline 2
Screen('FrameRect', w, Cfg.screen.color_rect, Cfg.screen.points_rect , Cfg.screen.pen_width);
Screen('FillRect', w,[0 0 0],Cfg.screen.cross);
time_end = Screen('Flip', w);
WaitSecs(Cfg.timing.baseline_2);
trial_struct(k,5) = time_end-time_start;

%Save output file for current subject and run
save(fullfile(Cfg.path.save, sprintf('SUB%02d_RUN%02d_rs_log', subNum, runNum)), 'Cfg', 'trial_struct');
PsychPortAudio('Close', pahandle);
Screen('Close',w);
ShowCursor();
end
