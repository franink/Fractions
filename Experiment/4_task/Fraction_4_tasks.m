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

%Use number in filename to counter balance
s_nbr = str2num(filename(6:8));

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
LR = 0;

% counter balance task order
% order [0,1] = match 1st; fraction comparison 2nd
% order [2,3] = fraction comparison 1; match 2nd
order = mod(s_nbr,4);
sum_task = [0 1];
fcomp_task = [2 3];
nline_task = [0 2];
dot_task = [1 3];
if ismember(order, sum_task);
    % Summation task
    p.order = 'Sum First';
end;
if ismember(order, fcomp_task);
    % Summation task
    p.order = 'FComp First';
end;
   

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
p.nStim = 4;
p.tasks = {'Sum', 'FracComp', 'NumLine', 'Dots'}; 
p.trialSecs = p.fixation + p.consider + (p.decision*p.pct_catch);


%Randomize stims for all parts of experiment
rng shuffle;

%assign randomly catch trials to each stim
%Only for one block. This will then be replicated for every other block 
%to insure they all have the same time length
ctch_nbr = round((p.nRepeats/p.runs)*p.pct_catch); 
ctch = [ones(ctch_nbr,1); zeros((p.nRepeats/p.runs) - ctch_nbr,1)];
TestFracSum = zeros(p.nRepeats*p.nStim,4); %num, denom, catch, sum probe
TestFracsComp = zeros(p.nRepeats*p.nStim,5); %num, denom, catch, n probe, d probe 
TestFracsLine = zeros(p.nRepeats*p.nStim,5); %num, denom, catch, n probe, d probe

%Dot task
TestDots = zeros(p.nRepeats*p.nStim,5); %num, denom, catch, n probe, d probe

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

%Finally dot task
for ii = 1:p.nStim;
    for kk = 1:p.runs;
        ctch_temp = ctch(randperm(p.nRepeats/p.runs)); %Just one block
        for jj = 1:p.nRepeats/p.runs;
            TestDots(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 1:2) = FracStim(ii,1:2);
            TestDots(ii+((kk-1)*(p.nStim*(p.nRepeats/p.runs))+((jj-1)*(p.nStim))), 3) = ctch_temp(jj);
        end
    end
end
    
% Now add the probes for all catch trials and add '-1' to non catch trials

% Summation task
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

%Finally Dot Task
TestDots(:,4:5) = -1;
probes = 1:ctch_nbr*p.runs;
IndStim = 0:p.nStim:p.nStim*(p.nRepeats-1);
for ii = 1:p.nStim;
    probes = probes(randperm(length(probes)));
    IndStimTmp = IndStim + ii;
    IndCatch = find(TestDots(IndStimTmp,3) == 1);
    TestDots(IndStimTmp(IndCatch),4) = FracStim(ii,((probes*2)+1));
    TestDots(IndStimTmp(IndCatch),5) = FracStim(ii,((probes*2)+2));
end


%Shuffle trials within block

%First for summation
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

% Now for dot line
for ii = 1:p.nRepeats
    TestDots(((ii-1)*p.nStim)+1:((ii-1)*p.nStim)+p.nStim,:) = TestDots(randperm(p.nStim)+(p.nStim*(ii-1)),:);
end


% Create Results files
p.sumResults = cell(p.nStim*(p.nRepeats/p.runs)+1,20,p.runs);
p.compResults = cell(p.nStim*(p.nRepeats/p.runs)+1,21,p.runs);
p.numlineResults = cell(p.nStim*(p.nRepeats/p.runs)+1,21,p.runs);
p.dotsResults = cell(p.nStim*(p.nRepeats/p.runs)+1,21,p.runs);
p.time_Runs = cell((p.runs+1),length(p.tasks));


%Get Labels
for ii = 1:p.runs
    p.sumResults(1,:,ii) = {'Num','Denom','Value','Sum_Fraction','Sum_Probe','Correct','Response','RT','Acc','Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};    
    p.compResults(1,:,ii) = {'Num','Denom','Value','Num_Probe','Denom_Probe','Value_Probe','Correct','Response','RT', 'Acc', 'Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};
    p.numlineResults(1,:,ii) = {'Num','Denom','Value','Num_Probe','Denom_Probe','Value_Probe','Correct','Response','RT','Acc','Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};
    p.dotsResults(1,:,ii) = {'Num','Denom','Value','Num_Probe','Denom_Probe','Value_Probe','Correct','Response','RT','Acc','Points','Trial','Block','fix_onset','cons_onset','decision_onset','decision_end','catch','fix_onset_real','cons_onset_real','decision_onset_real'};
end

p.time_Runs(1,:) ={'Time_Sum', 'Time_Comparison', 'Time_NumLine', 'Time_Dots'}; 

%Add catch information to results struct (needed to construct timing)
ctr = 0;
for jj = 1:p.runs;
    for ii = 2:length(p.sumResults(:,1,1));
        ctr = ctr + 1;
        p.sumResults(ii,17,jj) = {TestFracSum(ctr,3)};
        p.compResults(ii,18,jj) = {TestFracsComp(ctr,3)};
        p.numlineResults(ii,18,jj) = {TestFracsLine(ctr,3)};
        p.dotsResults(ii,18,jj) = {TestDots(ctr,3)};
    end
end

% Separate runs into different 3D matrices to control time indpeendently
% for each run
TestSum = zeros(p.nStim*(p.nRepeats/p.runs),4,p.runs);
TestFComp = zeros(p.nStim*(p.nRepeats/p.runs),5,p.runs);
TestNLine = zeros(p.nStim*(p.nRepeats/p.runs),5,p.runs);
Test3DDots = zeros(p.nStim*(p.nRepeats/p.runs),5,p.runs);

for ii = 1:p.runs
    TestSum(:,:,ii) = TestFracSum(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
    TestFComp(:,:,ii) = TestFracsComp(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
    TestNLine(:,:,ii) = TestFracsLine(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
    Test3DDots(:,:,ii) = TestDots(1+((ii-1)*p.nStim*(p.nRepeats/p.runs)):(p.nStim*(p.nRepeats/p.runs))+((ii-1)*(p.nStim*(p.nRepeats/p.runs))),:);
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

%Fraction comparison
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

% Finally for dots
for jj = 1:p.runs
    end_ramp_up = p.ramp_up; %practice time might include ramp_up
    current_time = end_ramp_up; %keeps track of time, starts with time after practice
    for ii = 1:length(p.dotsResults(:,1,1))-1;
        p.dotsResults(ii+1,14,jj) = {current_time}; %fixation onset
        current_time = current_time + p.fixation; %end of fixation
        p.dotsResults(ii+1,15,jj) = {current_time}; %consider onset
        current_time = current_time + p.consider; %end of consider
        p.dotsResults(ii+1,16,jj) = {current_time}; %decision onset
        current_time = current_time + (p.decision * p.dotsResults{ii+1,18,jj}); %end of decision if ctch 1 = 0 current time does not move
        p.dotsResults(ii+1,17,jj) = {current_time}; %end of decision
    end
end

% Start of experiment
points = 0; %This initializes points for accuracy calculation
block_points = 0;
%Introductory instructions
DisplayInstructsInt;

% counter balance task order
% order [0,1] = sum 1st; fraction comparison 2nd
% order [2,3] = fraction comparison 1; match 2nd
if ismember(order, sum_task);
    % Summation task
    [p, points, block_points] = Sum_Loop(filename, LR, win, color, p, points, TestSum, block_points);
    
    % Fraction Comparison task:
    [p, points, block_points] = FComp_Loop(filename, LR, win, color, p, points, TestFComp, block_points);
end;

if ismember(order, fcomp_task);
    % Fraction Comparison task:
    [p, points, block_points] = FComp_Loop(filename, LR, win, color, p, points, TestFComp, block_points);
    
    % Summation task
    [p, points, block_points] = Sum_Loop(filename, LR, win, color, p, points, TestSum, block_points);
end;
    

% Fraction numberline task:
[p, points, block_points] = FNLine_Loop(filename, LR, win, color, p, points, TestNLine, block_points);

% % counter balance task order when Dot task exists
% % order [0,1] = NLine 1st; Dot 2nd
% % order [2,3] = Dot 1st; NLine 2nd
% nline_task = [0 2];
% dot_task = [1 3];
% if ismember(order, nline_task);
%     % Fraction numberline task: 
%     [p, points, block_points] = FNLine_Loop(filename, LR, win, color, p, points, TestNLine, block_points);
%     
%     % Dot task:
%     [p, points, block_points] = Dot_Loop(filename, LR, win, color, p, points, Test3DDots, block_points); %This can be changed Andrew
% end;
% if ismember(order, dot_task);
%     % Dot task:
%     [p, points, block_points] = Dot_Loop(filename, LR, win, color, p, points, Test3DDots, block_points); %This can be changed Andrew
%     
%     % Fraction numberline task: 
%     [p, points, block_points] = FNLine_Loop(filename, LR, win, color, p, points, TestNLine, block_points);
% end;

DrawCenteredNum('Thank You', win, color, 2);
    
%save results
save(filename, 'p')
ListenChar(0)
ShowCursor
%Show characters on matlab screen again
close all;
sca