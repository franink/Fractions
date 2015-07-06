function [p] = Run_Loop(filename, win, p, stim, dimStim)
%Controls the loop for each run of IEM task
%   returns p struct with all data, saves partial data if something fails

try
        
    DisplayInstructsPractice;
    
    %any practice we decide to do goes here
    
    DisplayInstructs4; %End of practice ask question and get ready to start this name can change if I don't have anythin else to show
    
    p.start_Exp =datestr(now); % for record purpose
    
    
    
    for r= 1:p.runs
        
        % wait for scanner trigger '5'
        DrawCenteredNum('Waiting for experimenter', win, p, 0.3);
        WaitTill('9');
        DrawCenteredNum('Waiting for scanner', win, p, 0.3);
        WaitTill('5'); %Use this only if used in a scanner that sends 5
        5
        DrawCenteredNum('Ready', win, p, 0.3);
        
%% Remember to uncomment this for the scanner        
        % Send trigger to scanner
%         s = serial('/dev/tty.usbmodem12341', 'BaudRate', 57600);
%         fopen(s);
%         fprintf(s, '[t]');
%         fclose(s);
%% Uncomment above for scanner
        
        start_t = GetSecs;
        
        p.startRun(r) = start_t;
        WaitTill(start_t + p.ramp_up);
        
        for t = 1:p.nTrials
            
            end_ITI = p.StimOnset(t,r) + start_t;
            end_Stim = p.StimEnd(t,r) + start_t;
            
            p = TrialLoop(p,t,r,stim, dimStim, end_ITI, end_Stim, start_t, win); %This loop draws a fixation and draws a stim
            
        end
        
        p.endRun(r) = GetSecs;
        p.durRun(r) = p.endRun(r) - p.startRun(r);
        
        DisplayInstructs3; %Rest break (Again Number of file might change once I figure how many instructions I need
    end
    
    p.endExp = datestr(now);
    
    catch
    ple
    ShowCursor;
    sca
    save([filename '_catch']);
    save(filename, 'p');
    ListenChar(1);

end

