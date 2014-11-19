function [p, points] = Dot_Loop(filename, LR, win, color, p, points, Test3DDots)

try
    task = 'keyb';
    
    DisplayInstructsX; %Change number of instruction to Dot instructions
    
    %practice trials
    fix = 'X';
    prac1 = [1 2 1 6 10];
    prac2 = [1 3 0 -1 -1];
    prac3 = [16 24 1 13 20];
    
    %TO DO
    
    DisplayInstructs4 %End of practice ask question and get ready to start
    
    blockNbr_NLine = 0;
    
    % The idea is the kk will signal
    % which portion of the #D matrix TestNLine will be used for the
    % rest of the code and in principle the rest should not be changed
    start_t0 = GetSecs;
    p.start_NLine=datestr(now); % for record purpose
    
    for kk = 1:p.runs;
    
        
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for scanner', win, color, 0.5);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        start_t = GetSecs;
        
        %TO DO 
        
        %below is a sample template of how I am constructing the loop
        %and stimuli from the number line task
    
%         for ii = 1:(p.nRepeats/p.runs);
%             blockNbr_NLine = blockNbr_NLine+1;
%             for jj = 1:p.nStim;
%                 trialNbr_NLine = (p.nStim * (blockNbr_NLine-1)) + jj; % This counts across blocks
%                 trialNbr = (p.nStim * (ii-1)) + jj; %This counts within block
%                 end_fix = p.numlineResults{trialNbr+1,15,kk} + start_t;
%                 end_cons = p.numlineResults{trialNbr+1,16,kk} + start_t;
%                 end_decision = p.numlineResults{trialNbr+1,17,kk} + start_t;
%                 DrawCenteredNum_Abs('X', win, color);
%                 p.numlineResults(trialNbr+1,19,kk) = {GetSecs - start_t}; %Real onset of fixation
%                 WaitTill(end_fix);
%                 p.numlineResults(trialNbr+1,20,kk) = {GetSecs - start_t}; %Real onset of consider
%                 p.numlineResults(trialNbr+1,1:3,kk) = ConsiderSlow_Abs(Test3DDots(trialNbr,:,kk), win, color, task, end_cons);
%                 WaitTill(end_cons);
%                 p.numlineResults(trialNbr+1,21,kk) = {GetSecs - start_t}; %Real onset of decision
%                 p.numlineResults(trialNbr+1,4:11,kk) = FractLineRGSlow_Abs(Test3DDots(trialNbr,:,kk), win, 600, 1, color, end_decision, p.numlineResults{trialNbr+1,18,kk}, points, LR);
%                 WaitTill(end_decision);
%                 p.numlineResults(trialNbr+1,12,kk) = {trialNbr_NLine};
%                 p.numlineResults(trialNbr+1,13,kk) = {blockNbr_NLine};
%                 points = p.numlineResults{trialNbr+1,11,kk};
%             end
%         end
%         end_t = GetSecs - start_t;
%         p.time_Runs(kk+1,3) = {end_t}; 
%         DisplayInstructs2;
     end

    p.finish_NLine = datestr(now);
    
catch
    sca
    ple
    ShowCursor
    save([filename '_catch4']);
end