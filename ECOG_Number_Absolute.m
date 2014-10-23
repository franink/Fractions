% Code for fMRI experiment of fractions using absolute time instead of
% relative time for more precision.
% Modified from Cameron McKenzie's code
% Tanks to Xiangrui Li for the codes for WaitTill and ReadKey.

%make sure no Java problems
PsychJavaTrouble;

%Parameter to scale size on monitor... pixel per cm adjustment
ppc_adjust = 38/23; % Need to ask what these numbers mean exactly and why these and not others.

%Filename to save data
filename = getFracFilename();

%Cursor helps no one here - kill it
HideCursor;


%Don't show characters on matlab screen
ListenChar(2);

%load up stimuli
load ECOG_Stims;

%Randomize stims for three parts of experiment
%Don't allow two consecutive equal fractions
rng shuffle;

a = 1:18;
b = 19:36;
c = 37:54;
d = 55:72;
% e = 73:90;
% f = 91:108;
% g = 109:126;
% h = 127:144;

% Uses a-d to create 8 (or 4) shuffled sets of the 18 fractions
%a-d are different sets with different match probes
TestNumMatch = [FracStim(a(randperm(18)), :);
                FracStim(b(randperm(18)), :);
                FracStim(c(randperm(18)), :);
                FracStim(d(randperm(18)), :)];
                %FracStim(e(randperm(18)), :);
                %FracStim(f(randperm(18)), :);
                %FracStim(g(randperm(18)), :);
                %FracStim(h(randperm(18)), :)];

% TestFracsComp = [FracStim(a(randperm(18)), :);
%                 FracStim(b(randperm(18)), :);
%                 FracStim(c(randperm(18)), :);
%                 FracStim(d(randperm(18)), :);
%                 FracStim(e(randperm(18)), :);
%                 FracStim(f(randperm(18)), :);
%                 FracStim(g(randperm(18)), :);
%                 FracStim(h(randperm(18)), :)]

TestFracsLine = [FracStim(a(randperm(18)), :);
                FracStim(b(randperm(18)), :);
                FracStim(c(randperm(18)), :);
                FracStim(d(randperm(18)), :)];
                %FracStim(e(randperm(18)), :);
                %FracStim(f(randperm(18)), :);
                %FracStim(g(randperm(18)), :);
                %FracStim(h(randperm(18)), :)];


%Setup experiment parameters
p.practice_time = 10; % Need to figure out how much practice I need
p.fixation = 6;
p.consider = 3;
p.decision = 3;
p.pct_catch = 0.5; % proportion of trials that have a test (decision) phase
p.runs = 2; %this can be number of tasks or number of runs
p.nRepeats = 2; %repeats per run This is probably going to be larger than 4 
p.nStim = 2;
p.tasks = {'NumMatch', 'NumLine'};
p.trialSecs = p.fixation + p.consider + p.decision;
p.runSecs = (p.trialSecs * p.nStim * p.nRepeats) + p.practice_time;
p.nMatchResults = cell(length(TestNumMatch)+1,16);
p.numlineResults = cell(length(TestFracsLine)+1,16);
p.time_Runs = cell(2,p.runs);

% Code to decide which trials will have a decision phase based on
% p.pct_catch
%first for nummatch
ctch_nbr = round(length(TestNumMatch)*p.pct_catch);
ctch = [ones(ctch_nbr,1); zeros(length(TestNumMatch) - ctch_nbr,1)];
ctch1 = ctch(randperm(length(ctch)));
ctch2 = ctch(randperm(length(ctch)));

%Get Labels
p.nMatchResults(1,:) = {'Num','Denom','Value','Cons_RT','Match','Correct','Response','RT','Acc', 'Trial', 'Block', 'fix_onset', 'cons_onset', 'decision_onset', 'decision_end', 'catch'};    
%fCompResults(1,:) = {'Num','Denom','Value','Cons_RT','Target','Correct','Response','RT','Acc'};
p.numlineResults(1,:) = {'Num','Denom','Value','Cons_RT','Mouse_Pos','Correct','Response','RT','Error', 'Trial', 'Block', 'fix_onset', 'cons_onset', 'decision_onset', 'decision_end', 'catch'};
p.time_Runs(1,:) ={'Time_Match', 'Time_NumLine'}; %this might change if number of runs changes

%Add catch information
p.nMatchResults(2:end,16) = ctch1;
p.numlineResults(2:end,16) = ctch2;

% Open a PTB Window on our screen
try
    screenid = min(Screen('Screens')); %Originally it was max instead of min changed it for testing purposes (max corresponds to secondary display)
    
    [win, winRect] = Screen('OpenWindow', screenid, WhiteIndex(screenid)/2);
    
    color = [255 255 255 255]; %Cam's value was 0 200 255
catch
end

% Setup the onsets for each stimulus
% simulates going through the whole run and kees track of time and catch
% events
end_practice = p.practice_time;
current_time = end_practice; %keeps track of time, starts with time after practice
for ii = 1:length(p.nMatchResults);
    p.nMatchResults(ii+1,12) = current_time; %fixation onset
    current_time = current_time + p.fixation; %end of fixation
    p.nMatchResults(ii+1,13) = current_time; %consider onset
    current_time = current_time + p.consider; %end of consider
    p.nMatchResults(ii+1,14) = current_time; %decision onset
    current_time = current_time + (p.decision * ctch1(ii)); %end of decision if ctch 1 = 0 current time does not move
    p.nMatchResults(ii+1,15) = current_time; %end of decision
end

% and now for numberline
end_practice = p.practice_time;
current_time = end_practice; %keeps track of time, starts with time after practice
for ii = 1:length(p.numlineResults);
    p.numlineResults(ii+1,12) = current_time; %fixation onset
    current_time = current_time + p.fixation; %end of fixation
    p.numlineResults(ii+1,13) = current_time; %consider onset
    current_time = current_time + p.consider; %end of consider
    p.numlineResults(ii+1,14) = current_time; %decision onset
    current_time = current_time + (p.decision * ctch2(ii)); %end of decision if ctch 1 = 0 current time does not move
    p.numlineResults(ii+1,15) = current_time; %end of decision
end

% Now I need to change the code of presentation to match
% the new time onset values created. This means using nMatchResults 12, 13
% ,14,15 to guide when things are on and off and make sure not to present
% the decision component when ctch = 0


% Stage 1 - NumMatch
try
       
    task = 'keyb';
    
    %DisplayInstructsNComp;
    DisplayInstructs1;
    
    % wait for scanner trigger '5'
    %startSecs=WaitTrigger; %Use this only if used in a scanner that sends 5
    start_t = GetSecs;
    p.start_match=datestr(now); % for record purpose
    

    %This needs to be fixed but is the beginning of the fixation code
    %Here probably there will be something about practice and fixation time
%     fixation = ['X', 'X'];
%     DrawCenteredFrac(fixation,win,color);
%     Screen('Flip', win);

    for ii = 1:p.nRepeats;
        for jj = 1:p.nStim;
            blockNbr_Match = ii;
            trialNbr_Match = (p.nStim * (blockNbr_Match-1)) + jj;
            end_fix = start_t + ((trialNbr_Match-1)*p.trialSecs) + p.fixation; %Remember to check this if you add practice
            end_cons = start_t + ((trialNbr_Match-1)*p.trialSecs) + p.fixation + p.consider;
            end_decision = start_t + ((trialNbr_Match-1)*p.trialSecs) + p.fixation + p.consider + p.decision;
            DrawCenteredNum_Abs('X', win, color);
            WaitTill(end_fix);
            %%% I need to pass end_time to the functions so that they can
            %%% use it to figure when to exit from the script
            p.nMatchResults(trialNbr_Match+1,1:4) = ConsiderSlow_Abs(TestNumMatch(trialNbr_Match,:), win, color, task,end_cons);
            %Screen('Flip',win);
            WaitTill(end_cons);
            p.nMatchResults(trialNbr_Match+1,5:9) = NumMatchSlow_Abs(TestNumMatch(trialNbr_Match,:), win, color,end_decision);
            WaitTill(end_decision);
            p.nMatchResults(trialNbr_Match+1,10) = {trialNbr_Match};
            p.nMatchResults(trialNbr_Match+1,11) = {blockNbr_Match};
        end
    end
    
    end_t = GetSecs - start_t;
    p.finish_match = datestr(now);
    p.time_Runs(2,1) = {end_t};
catch
    ple
    ShowCursor
    sca
    save([filename '_catch2']);

end

% Stage 2 Fraction numberline task:

try
    task = 'mouse';
    
    %A neat little script that displays instructions for section two
    %DisplayInstructs;
    DisplayInstructs3;
    
    start_t = GetSecs;
    p.start_NLine=datestr(now); % for record purpose
    
%This needs to be fixed but is the beginning of the fixation code
    %Here probably there will be something about practice and fixation time
%     fixation = ['X', 'X'];
%     DrawCenteredFrac(fixation,win,color);
%     Screen('Flip', win);


    for ii = 1:p.nRepeats;
            for jj = 1:p.nStim;
                blockNbr_NLine = ii;
                trialNbr_NLine = (p.nStim * (blockNbr_NLine-1)) + jj;
                end_fix = start_t + ((trialNbr_NLine-1)*p.trialSecs) + p.fixation; %Remember to check this if you add practice
                end_cons = start_t + ((trialNbr_NLine-1)*p.trialSecs) + p.fixation + p.consider;
                end_decision = start_t + ((trialNbr_NLine-1)*p.trialSecs) + p.fixation + p.consider + p.decision;
                DrawCenteredNum_Abs('X', win, color);
                WaitTill(end_fix);
                p.numlineResults(trialNbr_NLine+1,1:4) = ConsiderSlow_Abs(TestFracsLine(trialNbr_NLine,:), win, color, task, end_cons);
                WaitTill(end_cons);
                p.numlineResults(trialNbr_NLine+1, 5:9) = FractLineRGSlow_Abs(TestFracsLine(trialNbr_NLine,:), win, 600, 1, color, end_decision);
                WaitTill(end_decision);
                p.numlineResults(trialNbr_NLine+1,10) = {trialNbr_NLine};
                p.numlineResults(trialNbr_NLine+1,11) = {blockNbr_NLine};
            end
    end

    end_t = GetSecs - start_t;
    p.finish_NLine = datestr(now);
    p.time_Runs(2,2) = {end_t};
    DrawCenteredNum('Thank You', win, color, 2);
    
    
    
catch
    sca
    ple
    ShowCursor
    save([filename '_catch3']);
    Screen('Flip', win);

end

%save results
save(filename, 'p')
ListenChar(0);
ShowCursor;
%Show characters on matlab screen again
sca;
close all;