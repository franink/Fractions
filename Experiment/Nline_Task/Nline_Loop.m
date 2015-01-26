function [p, points, block_points] = Nline_Loop(filename, win, color, p, points, NlineTime, block_points)
%Controls the loop that executes fraction summation task
%returns p struct with all the results and stim logged and updated points
%for measure of accuracy

% Nline task

try
       
    
    DisplayInstructs1; 
    
    %practice trials
    p_points = 0;
    block_p_points = 0;
    fix = 'X';
    prac1 = [10 0.1];
    prac2 = [50 0.5];
    prac3 = [80 0.8];
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    block_p_points = NumLineSlow(prac1, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);
    block_p_points = NumLineSlow(prac2, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);
    block_p_points = NumLineSlow(prac3, win, color, p.decision, block_p_points);
    p_points = block_p_points;
    DisplayInstructsPractice;
    block_p_points = 0;
    prac4 = [20 0.2];
    prac5 = [25 0.25];
    prac6 = [95 0.95];
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    block_p_points = NumLineSlow(prac4, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    block_p_points = NumLineSlow(prac5, win, color, p.decision, block_p_points); %decision
    DrawCenteredNum(fix, win, color, p.fixation);%fixation
    block_p_points = NumLineSlow(prac6, win, color, p.decision, block_p_points); %decision
    p_points = block_p_points + p_points;
    DisplayInstructs4; %End of practice ask question and get ready to start   
    
    blockNbr_Nline = 0;
    
    % The idea is the kk will signal
    % which portion of the #D matrix TestSum will be used for the
    % rest of the code and in principle the rest should not be changed
    %start_t0 = GetSecs;
    p.start_Nline=datestr(now); % for record purpose
    for kk = 1:p.runs;
    
        block_points = points;
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for experimenter', win, color, 0.3);
        WaitTill('9');
        DrawCenteredNum('Waiting for scanner', win, color, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        start_t = GetSecs;
            
        for ii = 1:(p.nRepeats/p.runs);
            blockNbr_Nline = blockNbr_Nline+1;
            for jj = 1:p.nStim;
                trialNbr_Nline = (p.nStim * (blockNbr_Nline-1)) + jj; % This counts across blocks
                trialNbr = (p.nStim * (ii-1)) + jj; %This counts within block
                end_fix = p.NlineResults{trialNbr+1,12,kk} + start_t;
                end_decision = p.NlineResults{trialNbr+1,13,kk} + start_t;
                DrawCenteredNum_Abs('X', win, color);
                p.NlineResults(trialNbr+1,14,kk) = {GetSecs - start_t}; %Real onset of fixation
                WaitTill(end_fix);
                %%% I need to pass end_time to the functions so that they can
                %%% use it to figure when to exit from the script
                p.NlineResults(trialNbr+1,15,kk) = {GetSecs - start_t}; %Real onset of deciison
                p.NlineResults(trialNbr+1,3:8,kk) = NumLineSlow_Abs(NlineTime(trialNbr,:,kk), win, color, end_decision, points);
                WaitTill(end_decision);
                p.NlineResults(trialNbr+1,9,kk) = {trialNbr_Nline};
                p.NlineResults(trialNbr+1,10,kk) = {blockNbr_Nline};
                points = p.NlineResults{trialNbr+1,7,kk};
            end
        end
        end_t = GetSecs - start_t;
        p.time_Runs(kk+1,1) = {end_t};
        block_points = points - block_points;
        DrawCenteredNum(fix, win, color, 4);%fixation to pad end of scan
        DisplayInstructs2;
    end
    
    %end_t = GetSecs - start_t0;
    p.finish_Nline = datestr(now);
catch
    ple
    ShowCursor
    sca
    save([filename '_catch2']);
    save(filename, 'p');
    ListenChar(1);

end