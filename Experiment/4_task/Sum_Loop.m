function [p, points, block_points] = Sum_Loop(filename, LR, win, color, p, points, TestSum, block_points)
%Controls the loop that executes fraction summation task
%returns p struct with all the results and stim logged and updated points
%for measure of accuracy

% Summation task

try
       
    task = 'keyb';
    
    DisplayInstructs1; 
    
    %practice trials
    p_points = 0;
    block_p_points = 0;
    fix = 'X';
    prac1 = [1 2 1 5];
    prac2 = [1 3 0 -1];
    prac3 = [16 24 1 37];
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac1, win, color, task, p.consider);%consider
    block_p_points = SumSlow(prac1, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac2, win, color, task, p.consider); %No answer example
    DrawCenteredNum(fix, win, color, p.fixation);
    ConsiderSlow(prac3, win, color, task, p.consider);
    block_p_points = SumSlow(prac3, win, color, p.decision, block_p_points);
    p_points = block_p_points;
    DisplayInstructsPractice;
    block_p_points = 0;
    prac4 = [1 7 1 5];
    prac5 = [2 6 1 11];
    prac6 = [11 21 1 22];
    prac7 = [6 8 0 -1];
    prac8 = [10 26 1 37];
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac4, win, color, task, p.consider);%consider
    block_p_points = SumSlow(prac4, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac5, win, color, task, p.consider);%consider
    block_p_points = SumSlow(prac5, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac6, win, color, task, p.consider);%consider
    block_p_points = SumSlow(prac6, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac7, win, color, task, p.consider);%consider
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    ConsiderSlow(prac8, win, color, task, p.consider);%consider
    block_p_points = SumSlow(prac8, win, color, p.decision, block_p_points); %decision
    p_points = block_p_points + p_points;
    DisplayInstructs4; %End of practice ask question and get ready to start   
    
    blockNbr_Sum = 0;
    
    % The idea is the kk will signal
    % which portion of the #D matrix TestSum will be used for the
    % rest of the code and in principle the rest should not be changed
    start_t0 = GetSecs;
    p.start_sum=datestr(now); % for record purpose
    for kk = 1:p.runs;
    
        block_points = points;
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for experimenter', win, color, 0.3);
        WaitTill('9');
        DrawCenteredNum('Waiting for scanner', win, color, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
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
                WaitTill(end_cons);
                p.sumResults(trialNbr+1,20,kk) = {GetSecs - start_t}; %Real onset of deciison
                p.sumResults(trialNbr+1,4:10,kk) = SumSlow_Abs(TestSum(trialNbr,:,kk), win, color, end_decision, p.sumResults{trialNbr+1,17,kk}, points, LR);
                WaitTill(end_decision);
                p.sumResults(trialNbr+1,11,kk) = {trialNbr_Sum};
                p.sumResults(trialNbr+1,12,kk) = {blockNbr_Sum};
                points = p.sumResults{trialNbr+1,10,kk};
            end
        end
        end_t = GetSecs - start_t;
        p.time_Runs(kk+1,1) = {end_t};
        block_points = points - block_points;
        DrawCenteredNum(fix, win, color, 4);%fixation to pad end of scan
        DisplayInstructs2;
    end
    
    end_t = GetSecs - start_t0;
    p.finish_sum = datestr(now);
catch
    ple
    ShowCursor
    sca
    save([filename '_catch2']);
    save(filename, 'p');
    ListenChar(1);

end