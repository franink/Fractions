% Code for fMRI experiment of numberlines using absolute time instead of
% relative time for more precision.
% Modified from Cameron McKenzie's code
% Tanks to Xiangrui Li for the codes for WaitTill and ReadKey.
%make sure no Java problems
PsychJavaTrouble;
rng shuffle;

%Parameter to scale size on monitor... pixel per cm adjustment
ppc_adjust = 38/23; % Need to ask what these numbers mean exactly and why these and not others.

% In case previous subject was not cleared
clear Instruct;

%Filename to save data
filename = getNlineFilename();

%Use number in filename to counter balance
s_nbr = str2num(filename(7:11));

% counter balance hand
% odds left= yes/larger
% evens right = yes/larger
% odds = 1; evens = 0
%Commented out because we are changing to a different response box
% LR = mod(s_nbr,2);
% if LR == 0;
%     p.LeftHand = 'Smaller';
% end;
% if LR == 1;
%     p.LeftHand = 'Larger';
% end;

% counter balance task order
% order [0] = match 1st; fraction comparison 2nd
% order [1] = fraction comparison 1; match 2nd
% order [0] = match 1st; fraction comparison 2nd

%Setup experiment parameters
p.ramp_up = 4; %original 14

p.Mean_ITI = 4.5; %average 5s This are with decision of 2
p.Mean_hold = 4; %Average 4.5s
p.decision = 3;
p.consider = 1; %Includes the time for the box in original design
%Make sure that repeats is divisible by runs
p.runs = 4; 
p.nStim = 16;
p.ntasks = 3;
p.tasks = {'Nline'}; 
p.trialSecs = p.consider + p.decision +p.Mean_hold + p.Mean_ITI;
p.lineLength = 1500;
p.speed = 6;

%% Checkerboard stuff
p.flickerFreq   = 6; % Hz
p.flickerPer  = 1/p.flickerFreq; % s
p.stimContrast = 1;

% monitor stuff
p.refreshRate = 60; % refresh rate is normally 100 but change this to 60 when on laptop!
p.vDistCM = 277; %CNI
p.screenWidthCM = 58.6; % CNI
%p.vDistCM = 120; %desktop
%.screenWidthCM = 40; % desktop
p.usedScreenSizeDeg = 12;

%stimulus geometry (in degrees, note that these vars have the phrase 'Deg'
%in them, used by pix2deg below)
p.radDeg = p.usedScreenSizeDeg/8; %edge of stim touches borders of screen
p.sfDeg = .6785; %TS parameter value, might need to be changed

p.backColor     = [128, 128, 128];      % background color

%fixation point properties
p.fixColor      = [250, 1, 1];%[155, 155, 155];
% p.fixSizeDeg    = .25 * .4523;                  % size of dot
p.fixSizeDeg    = .1131;
p.appSizeDeg    = p.fixSizeDeg * 4;     % size of apperture surrounding dot

% font stuff
p.fontSize = 40;    
p.fontName = 'HELVETICA';   
p.textColor = [255, 255, 255];

% --------------------Screen properties----------------------------%

p.LUT = 0:255;
% correct all the colors
p.fixColor = p.LUT(p.fixColor)';
p.textColor = p.LUT(p.textColor)';
%% END of checkerboard parameters

orders = [1 1 1];


p.run_order = zeros(p.runs,p.ntasks);
for i = 1:p.runs
    %p.run_order(i,:) = [3 1 2];
    p.run_order(i,:) = orders;
end



%Cursor helps no one here - kill it
HideCursor;


%Don't show characters on matlab screen
ListenChar(2);

%load up stimuli
load NlineStim;
load NeglineStim;
load WordStim;

ctch_nbr = p.runs * p.nStim/4;
catch_run = [zeros(1, p.nStim - ctch_nbr) repmat(1:p.runs,1,p.nStim/4)];
catch_run = catch_run(randperm(length(catch_run)));
NlineStim(:,2) = catch_run;

TestNline = cell(p.runs*p.ntasks*p.nStim,5); %probe, line_pct, catch, catch syllable, task

%Construct list of stimuli
for ii = 1:p.runs;
    for jj = 1:p.ntasks;
        for kk = 1:p.nStim;    
            if p.run_order(ii,jj) == 1;
                TestNline(((ii-1)*p.nStim*p.ntasks) + ((jj-1)*p.nStim) + kk, 1:2) = [{NlineStim(kk,1)}, {NlineStim(kk,1)/100}];
                if NlineStim(kk,2) == ii
                    TestNline(((ii-1)*p.nStim*p.ntasks) + ((jj-1)*p.nStim) + kk, 3) = {1};
                else
                    TestNline(((ii-1)*p.nStim*p.ntasks) + ((jj-1)*p.nStim) + kk, 3) = {0};
                end
                TestNline(((ii-1)*p.nStim*p.ntasks) + ((jj-1)*p.nStim) + kk, 5) = {p.run_order(ii,jj)};
            end
        end
    end
end

%Shuffle trials within block

%First for Nline
%For each repetition(indexed at nStim intervals), scramble the order within
%that interval
for ii = 1:p.runs
    for jj = 1:p.ntasks
        TestNline((((ii-1)*p.nStim*p.ntasks) + (jj-1)*p.nStim)+1:(((ii-1)*p.nStim*p.ntasks) + (jj-1)*p.nStim)+p.nStim,:) = TestNline(randperm(p.nStim) + (p.nStim*(jj-1)) + ((ii-1)*p.nStim*p.ntasks),:);
    end
end

% Create Results files
p.NlineResults = cell(p.nStim*p.ntasks+1,33,p.runs);

p.time_Runs = cell(2,p.runs);
p.task_transition = cell(length(p.tasks)+1,p.runs);

%Get Labels
for ii = 1:p.runs
    p.NlineResults(1,:,ii) = {'Task','Probe','Line_pct','catch','iti','hold','mouse_pos','Correct','Response','RT','Error','RTHold','Click','TestX','Points','Move','Slow','Wrong','BadPress','MouseTrack','Trial','Block','ITI_onset','consider_onset','hold_onset','decision_onset','decision_end','ITI_onset_real','consider_onset_real','hold_onset_real','decision_onset_real','decision_end_real','catch_probe'};
end

p.time_Runs(1,:) ={'Run_1', 'Run_2', 'Run_3', 'Run_4'};
%p.time_Runs(1,:) ={'Run_1', 'Run_2'};
p.task_transition(1,:) = {'Run_1', 'Run_2', 'Run_3', 'Run_4'};
%p.task_transition(1,:) = {'Run_1', 'Run_2'};

% Separate runs into different 3D matrices to control time indpeendently
% for each run
NlineTest = cell(p.nStim * p.ntasks, 5, p.runs);

for ii = 1:p.runs
    NlineTest(:,:,ii) = TestNline(1+((ii-1)*p.nStim*p.ntasks):p.nStim*p.ntasks+((ii-1)*p.nStim*p.ntasks),:);
end


% Open a PTB Window on our screen
try
    screenid = min(Screen('Screens')); %Originally it was max instead of min changed it for testing purposes (max corresponds to secondary display)

    [win, winRect] = Screen('OpenWindow', screenid, WhiteIndex(screenid)/2);
    
    color = [255 255 255 255]; %Cam's value was 0 200 255
catch
end

%% checkerboard stuff after screen initialization
p.sRect = winRect;
% Enable alpha blending with proper blend-function. We need it
% for drawing of smoothed points:
Screen('BlendFunction', win, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% test the refesh properties of the display
p.fps=Screen('FrameRate',win);          % frames per second
p.ifi=Screen('GetFlipInterval', win);   % inter-frame-time
if p.fps==0                           % if fps does not register, then set the fps based on ifi
    p.fps=1/p.ifi;
end
p.flickerFrames = round(1/p.flickerFreq*p.fps);

% make sure the refreshrate is ok
if abs(p.fps-p.refreshRate)>5
    Screen('CloseAll');
    disp('CHANGE YOUR REFRESH RATE')
    ListenChar(0);
    clear all;
    return;
end

% convert relevant timing stuff to vid frames for stim presentation
p.stimExposeCon = round((p.consider*1000)./(1000/p.refreshRate));
p.stimExposeDec = round((p.decision*1000)./(1000/p.refreshRate));

% set the priority up way high to discourage interruptions
Priority(MaxPriority(win));

% convert from degrees to pixel units
p = deg2pix(p);


% generate checkerboards we use...
p.stimContrast = 1;
c = make_checkerboard(p.radPix,p.sfPix,p.stimContrast);
%c{1}
stim(1)=Screen('MakeTexture', win, c{1});
stim(2)=Screen('MakeTexture', win, 127*ones(size(c{2})));
stim(3)=Screen('MakeTexture', win, c{2});
%stim(3)
        
p.flickerSequCon = repmat([ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2)) 3*ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2))],1,(0.5)*round(p.stimExposeCon/p.flickerFrames));
p.flickerSequDec = repmat([ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2)) 3*ones(1,round(p.flickerFrames/2)) 2*ones(1,round(p.flickerFrames/2))],1,(0.5)*round(p.stimExposeDec/p.flickerFrames));

%% End of checkerboard


% Setup the onsets for each stimulus
% simulates going through the whole run and keeps track of time and catch
% events
% 16 times to be sampled randomly to each of the 16 stim in a particular
% run and particular task

ITI_Jits = [3.5:0.5:7 repmat(3:0.5:4.5,1,2)]; % Make sure to change this to values for fMRI
Hold_Jits = [3:00000.5:6.5 repmat(2.5:0.5:4,1,2)];% Make sure to change this to values for fMRI

for jj = 1:p.runs
    end_ramp_up = p.ramp_up; % after ramp_up the first nline begins
    current_time = end_ramp_up - 2; %keeps track of time, starts with time after ramp_up
    for kk = 1:p.ntasks
        ITI_Jits = datasample(ITI_Jits, 16, 'Replace', false);
        Hold_Jits = datasample(Hold_Jits, 16, 'Replace', false);
        if kk ==1;
            p.task_transition{kk+1,jj} = {0};
        else
            p.task_transition{kk+1,jj} = {current_time - 4};
        end
        current_time = current_time + 2;
        for ii = 1:p.nStim;
            p.NlineResults((ii+1) + ((kk-1)*p.nStim),23,jj) = {current_time}; %ITI onset
            ITI = ITI_Jits(ii);
            p.NlineResults((ii+1) + ((kk-1)*p.nStim),5,jj) = {ITI}; %ITI
            current_time = current_time + ITI; %end of ITI 
            p.NlineResults((ii+1) + ((kk-1)*p.nStim),24,jj) = {current_time - 0.5}; %consider onset -0.5 accounts for the moment box appears
            current_time = current_time + p.consider; %end of consider
            p.NlineResults((ii+1) + ((kk-1)*p.nStim),25,jj) = {current_time}; %hold onset
            HOLD = Hold_Jits(ii);
            p.NlineResults((ii+1) + ((kk-1)*p.nStim),6,jj) = {HOLD};
            current_time = current_time + HOLD; %end of hold
            p.NlineResults((ii+1) + ((kk-1)*p.nStim),26,jj) = {current_time}; %decision onset
            current_time = current_time + p.decision; %end of decision
            p.NlineResults((ii+1) + ((kk-1)*p.nStim),27,jj) = {current_time}; %end of decision
        end
        current_time = current_time + 4; %feedback_end
    end
end


% Start of experiment
points = 0; %This initializes points for accuracy calculation
block_points = 0;
%Introductory instructions
DrawCenteredNum('Welcome', win, color, 0.5);
WaitTill('9');
DisplayInstructsInt;

%Initialize run loop
[p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTest, block_points, p.lineLength, stim);
    
DrawCenteredNum('Thank You', win, color, 2);
    
%save results
save(filename, 'p')
ListenChar(1);
ShowCursor;
%Show characters on matlab screen again
close all;
sca