% Code for fMRI experiment of fractions using absolute time instead of
% relative time for more precision.
% Modified from Cameron McKenzie's code
% Tanks to Xiangrui Li for the codes for WaitTill and ReadKey.

%make sure no Java problems
PsychJavaTrouble;

%Parameter to scale size on monitor... pixel per cm adjustment
ppc_adjust = 38/23; % Need to ask what these numbers mean exactly and why these and not others.

% In case previous subject was not cleared
clear Instruct;

%Filename to save data
filename = getFracFilename();

%Use number in filename to counter balnce
s_nbr = str2num(filename(6:8));

% counter balance hand
% odds left= yes/larger
% evens right = yes/larger
% odds = 1; evens = 0
LR = mod(s_nbr,2);

% counter balance task order
% order [0,1] = match 1st; fraction comparison 2nd
% order [2,3] = fraction comparison 1; match 2nd
order = mod(s_nbr,4);

%Cursor helps no one here - kill it
HideCursor;


%Don't show characters on matlab screen
ListenChar(2);

%load up stimuli
load FracStim;

%Setup experiment parameters
p.ramp_up = 8; %This number needs to be changed once we know TR (this should be TR*4)
p.fixation = 3;
p.consider = 2;
p.decision = 2.5;
p.pct_catch = 0.4; % proportion of trials that have a test (decision) phase
%Make sure that repeats is divisible by runs
p.runs = 2; %within a single task
p.tasks = 3; %This will potentially be 4 tasks
p.nRepeats = 4; %repeats per run. Divisivle by p.runs 
p.nStim = 3;
p.tasks = {'Sum', 'FracComp', 'NumLine'}; %This will potentially be 4 tasks
p.trialSecs = p.fixation + p.consider + (p.decision*p.pct_catch);


%Randomize stims for all parts of experiment
%Don't allow two consecutive equal fractions
rng shuffle;

%assign randomly catch trials to each stim
%Only for one block. This will then be replicated ofr every other block 
%to insure they all have the same time length
ctch_nbr = round((p.nRepeats/p.runs)*p.pct_catch); 
ctch = [ones(ctch_nbr,1); zeros((p.nRepeats/p.runs) - ctch_nbr,1)];
%ctch_temp = ctch(tmp(randperm(p.nRepeats)));
TestFracSum = zeros(p.nRepeats*p.nStim,4); %num, denom, catch, sum probe
TestFracsComp = zeros(p.nRepeats*p.nStim,5); %num, denom, catch, n probe, d probe 
TestFracsLine = zeros(p.nRepeats*p.nStim,5); %num, denom, catch, n probe, d probe 

% First summation task
for ii = 1:p.nStim;
    for kk = 1:p.runs;
        ctch_temp = ctch(randperm(p.nRepeats/p.runs)); %Just one block
        for jj = 1:p.nRepeats/p.runs;
            TestFracSum(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 1:2) = FracStim(ii,1:2);
            TestFracSum(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 3) = ctch_temp(jj);
        end
    end
end

%Now for fraction comparison task
for ii = 1:p.nStim;
    for kk = 1:p.runs;
        ctch_temp = ctch(randperm(p.nRepeats/p.runs)); %Just one block
        for jj = 1:p.nRepeats/p.runs;
            TestFracsComp(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 1:2) = FracStim(ii,1:2);
            TestFracsComp(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 3) = ctch_temp(jj);
        end
    end
end

%Now for fraction NL task
for ii = 1:p.nStim;
    for kk = 1:p.runs;
        ctch_temp = ctch(randperm(p.nRepeats/p.runs)); %Just one block
        for jj = 1:p.nRepeats/p.runs;
            TestFracsLine(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 1:2) = FracStim(ii,1:2);
            TestFracsLine(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 3) = ctch_temp(jj);
        end
    end
end
    
% Now add the probes for all catch trials and add '-1' to non catch trials

% Summation task (missing until we decide what to do)
TestFracSum(:,4) = -1;
probes = 1:ctch_nbr*p.runs;
IndStim = 0:p.nStim:p.nStim*(p.nRepeats-1);
for ii = 1:p.nStim;
    probes = probes(randperm(length(probes)));
    IndStimTmp = IndStim + ii;
    IndCatch = find(TestFracSum(IndStimTmp,3) == 1);
    TestFracSum(IndStimTmp(IndCatch),4) = FracStim(ii,(probes+10));
end

%Now for Fraction Comparison
TestFracsComp(:,4:5) = -1;
probes = 1:ctch_nbr*p.runs;
IndStim = 0:p.nStim:p.nStim*(p.nRepeats-1);
for ii = 1:p.nStim;
    probes = probes(randperm(length(probes)));
    IndStimTmp = IndStim + ii;
    IndCatch = find(TestFracsComp(IndStimTmp,3) == 1);
    TestFracsComp(IndStimTmp(IndCatch),4) = FracStim(ii,((probes*2)+1));
    TestFracsComp(IndStimTmp(IndCatch),5) = FracStim(ii,((probes*2)+2));
end

%Now for Fraction NumberLine
TestFracsLine(:,4:5) = -1;
probes = 1:ctch_nbr*p.runs;
IndStim = 0:p.nStim:p.nStim*(p.nRepeats-1);
for ii = 1:p.nStim;
    probes = probes(randperm(length(probes)));
    IndStimTmp = IndStim + ii;
    IndCatch = find(TestFracsLine(IndStimTmp,3) == 1);
    TestFracsLine(IndStimTmp(IndCatch),4) = FracStim(ii,((probes*2)+1));
    TestFracsLine(IndStimTmp(IndCatch),5) = FracStim(ii,((probes*2)+2));
end


%Shuffle trials within block
for ii = 1:p.nRepeats
    TestFracSum(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestFracSum(randperm(p.nStim)+(p.nStim*(ii-1)),:);
end
% Now for fraction comparison
for ii = 1:p.nRepeats
    TestFracsComp(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestFracsLine(randperm(p.nStim)+(p.nStim*(ii-1)),:);
end
% Now for fraction number line
for ii = 1:p.nRepeats
    TestFracsLine(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestFracsLine(randperm(p.nStim)+(p.nStim*(ii-1)),:);
end


% Create Results files
p.sumResults = cell(p.nStim*(p.nRepeats/p.runs)+1,20,p.runs);
p.compResults = cell(p.nStim*(p.nRepeats/p.runs)+1,21,p.runs);
p.numlineResults = cell(p.nStim*(p.nRepeats/p.runs)+1,21,p.runs);
p.time_Runs = cell((p.runs+1),length(p.tasks));


%Get Labels
for ii = 1:p.runs
    % Match needs to be corrected once the task is decided
    p.sumResults(1,:,ii) = {'Num','Denom','Value','Sum_Fraction','Sum_Probe','Correct','Response','RT','Acc','Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};    
    p.compResults(1,:,ii) = {'Num','Denom','Value','Num_Probe','Denom_Probe','Value_Probe','Correct','Response','RT', 'Acc', 'Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};
    p.numlineResults(1,:,ii) = {'Num','Denom','Value','Num_Probe','Denom_Probe','Value_Probe','Correct','Response','RT','Acc','Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};
end

p.time_Runs(1,:) ={'Time_Sum', 'Time_Comparison', 'Time_NumLine'}; %this might change if number of runs changes

%Add catch information (needed to construct timing)
ctr = 0;
for jj = 1:p.runs
    for ii = 2:length(p.sumResults(:,1,1));
        ctr = ctr + 1;
        p.sumResults(ii,17,jj) = {TestFracSum(ctr,3)};
        p.compResults(ii,18,jj) = {TestFracsComp(ctr,3)};
        p.numlineResults(ii,18,jj) = {TestFracsLine(ctr,3)};
    end
end

% Separate runs into different 3D matrices
TestSum = zeros(p.nStim*(p.nRepeats/p.runs),4,p.runs);
TestFComp = zeros(p.nStim*(p.nRepeats/p.runs),5,p.runs);
TestNLine = zeros(p.nStim*(p.nRepeats/p.runs),5,p.runs);

for ii = 1:p.runs
    TestSum(:,:,ii) = TestFracSum(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
    TestFComp(:,:,ii) = TestFracsComp(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
    TestNLine(:,:,ii) = TestFracsLine(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
end


% Open a PTB Window on our screen
try
    screenid = max(Screen('Screens')); %Originally it was max instead of min changed it for testing purposes (max corresponds to secondary display)
    
    [win, winRect] = Screen('OpenWindow', screenid, WhiteIndex(screenid)/2);
    
    color = [255 255 255 255]; %Cam's value was 0 200 255
catch
end

% Setup the onsets for each stimulus
% simulates going through the whole run and kees track of time and catch
% events

% First for summation
for jj = 1:p.runs
    end_ramp_up = p.ramp_up; % after ramp_up the first fixation begins
    current_time = end_ramp_up; %keeps track of time, starts with time after ramp_up
    for ii = 1:length(p.sumResults(:,1,1))-1;
        p.sumResults(ii+1,13,jj) = {current_time}; %fixation onset
        current_time = current_time + p.fixation; %end of fixation
        p.sumResults(ii+1,14,jj) = {current_time}; %consider onset
        current_time = current_time + p.consider; %end of consider
        p.sumResults(ii+1,15,jj) = {current_time}; %decision onset
        current_time = current_time + (p.decision * p.sumResults{ii+1,17,jj}); %end of decision if ctch 1 = 0 current time does not move
        p.sumResults(ii+1,16,jj) = {current_time}; %end of decision
    end
end

%Second Fraction comparison
for jj = 1:p.runs
    end_ramp_up = p.ramp_up; %practice time might include ramp_up
    current_time = end_ramp_up; %keeps track of time, starts with time after practice
    for ii = 1:length(p.compResults(:,1,1))-1;
        p.compResults(ii+1,14,jj) = {current_time}; %fixation onset
        current_time = current_time + p.fixation; %end of fixation
        p.compResults(ii+1,15,jj) = {current_time}; %consider onset
        current_time = current_time + p.consider; %end of consider
        p.compResults(ii+1,16,jj) = {current_time}; %decision onset
        current_time = current_time + (p.decision * p.compResults{ii+1,18,jj}); %end of decision if ctch 1 = 0 current time does not move
        p.compResults(ii+1,17,jj) = {current_time}; %end of decision
    end
end


% and now for numberline
for jj = 1:p.runs
    end_ramp_up = p.ramp_up; %practice time might include ramp_up
    current_time = end_ramp_up; %keeps track of time, starts with time after practice
    for ii = 1:length(p.numlineResults(:,1,1))-1;
        p.numlineResults(ii+1,14,jj) = {current_time}; %fixation onset
        current_time = current_time + p.fixation; %end of fixation
        p.numlineResults(ii+1,15,jj) = {current_time}; %consider onset
        current_time = current_time + p.consider; %end of consider
        p.numlineResults(ii+1,16,jj) = {current_time}; %decision onset
        current_time = current_time + (p.decision * p.numlineResults{ii+1,18,jj}); %end of decision if ctch 1 = 0 current time does not move
        p.numlineResults(ii+1,17,jj) = {current_time}; %end of decision
    end
end


% Stage 1 - Summation task

try
       
    task = 'keyb';
    
    %DisplayInstructsNComp;
    DisplayInstructs1; %Need to change instructions to add hand variable
    %practice trials
    fix = 'X';
    prac1 = [1 2 1 5];
    prac2 = [1 3 0 -1];
    prac3 = [16 24 1 37];
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac1, win, color, task, p.consider);
    SumSlow(prac1, win, color, p.decision, 0); 
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac2, win, color, task, p.consider); %No answer example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac3, win, color, task, p.consider);
    SumSlow(prac3, win, color, p.decision, 0); 
    
    DisplayInstructs4 %End of practice ask question and get ready to start   
    
    points = 0; %This initializes points for accuracy calculation
    blockNbr_Sum = 0;
    
    % Need to implement this correctly. The idea is the kk will signal
    % which portion of the #D matrix testcomponent will be used for the
    % rest of the code and in principle the rest should not be changed
    % (except for names)
    start_t0 = GetSecs;
    p.start_sum_kk=datestr(now); % for record purpose
    for kk = 1:p.runs;
        
        % wait for scanner trigger '5'
        %startSecs=WaitTrigger; %Use this only if used in a scanner that sends 5
        % Don't have the function WaitTrigger probably works with WaitTill('5')
        start_t = GetSecs;
            
        for ii = 1:(p.nRepeats/p.runs);
            blockNbr_Sum = blockNbr_Sum+1;
            for jj = 1:p.nStim;
                trialNbr_Sum = (p.nStim * (blockNbr_Sum-1)) + jj; % This counts across blocks
                trialNbr = (p.nStim * (ii-1)) + jj; %This counts within block
                end_fix = p.sumResults{trialNbr+1,14,kk} + start_t;
                end_cons = p.sumResults{trialNbr+1,15,kk} + start_t;
                end_decision = p.sumResults{trialNbr+1,16,kk} + start_t;
                DrawCenteredNum_Abs('X', win, color);
                p.sumResults(trialNbr+1,18,kk) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_fix);
                %%% I need to pass end_time to the functions so that they can
                %%% use it to figure when to exit from the script
                p.sumResults(trialNbr+1,19,kk) = {GetSecs - start_t}; %Real onset of consider
                p.sumResults(trialNbr+1,1:3,kk) = ConsiderSlow_Abs(TestSum(trialNbr,:,kk), win, color, task,end_cons);
                %Screen('Flip',win);
                WaitTill(end_cons);
                p.sumResults(trialNbr+1,20,kk) = {GetSecs - start_t}; %Real onset of deciison
                p.sumResults(trialNbr+1,4:10,kk) = SumSlow_Abs(TestSum(trialNbr,:,kk), win, color, end_decision, p.sumResults{trialNbr+1,17,kk}, points);
                WaitTill(end_decision);
                p.sumResults(trialNbr+1,11,kk) = {trialNbr_Sum};
                p.sumResults(trialNbr+1,12,kk) = {blockNbr_Sum};
                points = p.sumResults{trialNbr+1,10,kk};
            end
        end
        end_t = GetSecs - start_t;
        p.time_Runs(kk+1,1) = {end_t};
        DisplayInstructs2;
    end
    
    end_t = GetSecs - start_t0;
    p.finish_sum = datestr(now);
catch
    ple
    ShowCursor
    sca
    save([filename '_catch2']);

end

% Stage 2 Fraction Comparison task:

try
    task = 'keyb';
    
    %A neat little script that displays instructions for section two
    %DisplayInstructs;
    DisplayInstructs5; %Need to fix instructions
    
    %practice trials
    fix = 'X';
    prac1 = [1 2 1 6 10];
    prac2 = [1 3 0 -1 -1];
    prac3 = [16 24 1 13 20];
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac1, win, color, task, p.consider);
    FCompSlow(prac1, win, color, p.decision); %Large example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac2, win, color, task, p.consider); %No answer example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac3, win, color, task, p.consider);
    FCompSlow(prac3, win, color, p.decision); % Small example
    
    DisplayInstructs4 %End of practice ask question and get ready to start
    
    blockNbr_NLine = 0;
    
    % Need to implement this correctly. The idea is the kk will signal
    % which portion of the #D matrix testcomponent will be used for the
    % rest of the code and in principle the rest should not be changed
    % (except for names)
    start_t0 = GetSecs;
    p.start_NLine=datestr(now); % for record purpose
    
    for kk = 1:p.runs;
    
        
        % wait for scanner trigger '5'
        %[~, startSecs]=WaitTill('5'); %Use this only if used in a scanner that sends 5
        start_t = GetSecs;
    
        for ii = 1:(p.nRepeats/p.runs);
            blockNbr_FComp = blockNbr_FComp+1;
            for jj = 1:p.nStim;
                trialNbr_FComp = (p.nStim * (blockNbr_FComp-1)) + jj; % This counts across blocks
                trialNbr = (p.nStim * (ii-1)) + jj; %This counts within block
                end_fix = p.compResults{trialNbr+1,15,kk} + start_t;
                end_cons = p.compResults{trialNbr+1,16,kk} + start_t;
                end_decision = p.compResults{trialNbr+1,17,kk} + start_t;
                DrawCenteredNum_Abs('X', win, color);
                p.compResults(trialNbr+1,19,kk) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_fix);
                p.compResults(trialNbr+1,20,kk) = {GetSecs - start_t}; %Real onset of consider
                p.compResults(trialNbr+1,1:3,kk) = ConsiderSlow_Abs(TestFComp(trialNbr,:,kk), win, color, task, end_cons);
                WaitTill(end_cons);
                p.compResults(trialNbr+1,21,kk) = {GetSecs - start_t}; %Real onset of decision
                p.compResults(trialNbr+1,4:11,kk) = FCompSlow_Abs(TestFComp(trialNbr,:,kk), win, 600, 1, color, end_decision, p.compResults{trialNbr+1,18,kk}, points);
                WaitTill(end_decision);
                p.compResults(trialNbr+1,12,kk) = {trialNbr_FComp};
                p.compResults(trialNbr+1,13,kk) = {blockNbr_FComp};
                points = p.compResults{trialNbr+1,10,kk};
            end
        end
        end_t = GetSecs - start_t;
        p.time_Runs(kk+1,2) = {end_t}; %This needs to be modified becaus task order is variable now (Need to change the '2')
        DisplayInstructs2;
    end

    end_t = GetSecs - start_t0;
    p.finish_FComp = datestr(now);    
    
catch
    sca
    ple
    ShowCursor
    save([filename '_catch3']);
    
end

% Stage 3 Fraction numberline task:

try
    task = 'keyb';
    
    %A neat little script that displays instructions for section two
    %DisplayInstructs;
    DisplayInstructs3;
    
    %practice trials
    fix = 'X';
    prac1 = [1 2 1 6 10];
    prac2 = [1 3 0 -1 -1];
    prac3 = [16 24 1 13 20];
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac1, win, color, task, p.consider);
    FractLineRGSlow(prac1, win, 600, 1, color, p.decision); %Large example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac2, win, color, task, p.consider); %No answer example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac3, win, color, task, p.consider);
    FractLineRGSlow(prac3, win, 600, 1, color, p.decision); % Small example
    
    DisplayInstructs4 %End of practice ask question and get ready to start
    
    blockNbr_NLine = 0;
    
    % Need to implement this correctly. The idea is the kk will signal
    % which portion of the #D matrix testcomponent will be used for the
    % rest of the code and in principle the rest should not be changed
    % (except for names)
    start_t0 = GetSecs;
    p.start_NLine=datestr(now); % for record purpose
    
    for kk = 1:p.runs;
    
        
        % wait for scanner trigger '5'
        %[~, startSecs]=WaitTill('5'); %Use this only if used in a scanner that sends 5
        start_t = GetSecs;
    
        for ii = 1:(p.nRepeats/p.runs);
            blockNbr_NLine = blockNbr_NLine+1;
            for jj = 1:p.nStim;
                trialNbr_NLine = (p.nStim * (blockNbr_NLine-1)) + jj; % This counts across blocks
                trialNbr = (p.nStim * (ii-1)) + jj; %This counts within block
                end_fix = p.numlineResults{trialNbr+1,15,kk} + start_t;
                end_cons = p.numlineResults{trialNbr+1,16,kk} + start_t;
                end_decision = p.numlineResults{trialNbr+1,17,kk} + start_t;
                DrawCenteredNum_Abs('X', win, color);
                p.numlineResults(trialNbr+1,19,kk) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_fix);
                p.numlineResults(trialNbr+1,20,kk) = {GetSecs - start_t}; %Real onset of consider
                p.numlineResults(trialNbr+1,1:3,kk) = ConsiderSlow_Abs(TestNLine(trialNbr,:,kk), win, color, task, end_cons);
                WaitTill(end_cons);
                p.numlineResults(trialNbr+1,21,kk) = {GetSecs - start_t}; %Real onset of decision
                p.numlineResults(trialNbr+1,4:11,kk) = FractLineRGSlow_Abs(TestNLine(trialNbr,:,kk), win, 600, 1, color, end_decision, p.numlineResults{trialNbr+1,18,kk}, points);
                WaitTill(end_decision);
                p.numlineResults(trialNbr+1,12,kk) = {trialNbr_NLine};
                p.numlineResults(trialNbr+1,13,kk) = {blockNbr_NLine};
                points = p.numlineResults{trialNbr+1,10,kk};
            end
        end
        end_t = GetSecs - start_t;
        p.time_Runs(kk+1,3) = {end_t}; %This needs to be modified becaus task order is variable now (Need to change the '3')
        DisplayInstructs2;
    end

    end_t = GetSecs - start_t0;
    p.finish_NLine = datestr(now);
    DrawCenteredNum('Thank You', win, color, 2);
    
    
    
catch
    sca
    ple
    ShowCursor
    save([filename '_catch4']);
    %Screen('Flip', win);

end

%save results
save(filename, 'p')
ListenChar(0)
ShowCursor
%Show characters on matlab screen again
close all;
sca